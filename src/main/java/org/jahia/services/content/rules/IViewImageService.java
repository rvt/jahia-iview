/**
 * This file is part of Jahia, next-generation open source CMS:
 * Jahia's next-generation, open source CMS stems from a widely acknowledged vision
 * of enterprise application convergence - web, search, document, social and portal -
 * unified by the simplicity of web content management.
 *
 * For more information, please visit http://www.jahia.com.
 *
 * Copyright (C) 2002-2012 Jahia Solutions Group SA. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 * As a special exception to the terms and conditions of version 2.0 of
 * the GPL (or any later version), you may redistribute this Program in connection
 * with Free/Libre and Open Source Software ("FLOSS") applications as described
 * in Jahia's FLOSS exception. You should have received a copy of the text
 * describing the FLOSS exception, and it is also available here:
 * http://www.jahia.com/license
 *
 * Commercial and Supported Versions of the program (dual licensing):
 * alternatively, commercial and supported versions of the program may be used
 * in accordance with the terms and conditions contained in a separate
 * written agreement between you and Jahia Solutions Group SA.
 *
 * If you are unsure which license is appropriate for your use,
 * please contact the sales department at sales@jahia.com.
 */

package org.jahia.services.content.rules;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.drools.ObjectFilter;
import org.drools.spi.KnowledgeHelper;
import org.jahia.api.Constants;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRPropertyWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.image.Image;
import org.jahia.services.image.JahiaImageService;
import org.jahia.settings.SettingsBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.PathNotFoundException;
import javax.jcr.RepositoryException;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Iterator;

/**
 * Imaging service.
 * User: toto
 * Date: Oct 21, 2008
 * Time: 5:25:31 PM
 */
public class IViewImageService {

    private static final Logger logger = LoggerFactory.getLogger(IViewImageService.class);

    private JahiaImageService imageService;

    public void setImageService(JahiaImageService imageService) {
        this.imageService = imageService;
    }

    private static IViewImageService instance;

    private static File contentTempFolder;

    public static IViewImageService getInstance() {
        if (instance == null) {
            synchronized (IViewImageService.class) {
                if (instance == null) {
                    instance = new IViewImageService();
                    contentTempFolder = new File(SettingsBean.getInstance().getTmpContentDiskPath());
                    if (!contentTempFolder.exists()) {
                        contentTempFolder.mkdirs();
                    }
                }
            }
        }
        return instance;
    }

    /**
     * Get image from imageNpde
     * @param imageNode
     * @param drools
     * @return
     * @throws Exception
     */
    private Image getImageWrapper(final AddedNodeFact imageNode, KnowledgeHelper drools) throws Exception {
        Iterator<?> it = drools.getWorkingMemory().iterateObjects(new ObjectFilter() {
            public boolean accept(Object o) {
                if (o instanceof Image) {
                    try {
                        return (((Image) o).getPath().equals(imageNode.getPath()));
                    } catch (RepositoryException e) {
                        e.printStackTrace();
                    }
                }
                return false;
            }
        });
        if (it.hasNext()) {
            return (Image) it.next();
        }
        Image iw = imageService.getImage(imageNode.getNode());
        if (iw == null) {
            return null;
        }
        drools.insertLogical(iw);
        return iw;
    }

    /**
     * Cropscale image rule for iView module
     * @param propertyWrapper
     * @param name
     * @param drools
     * @throws Exception
     */
    public void cropScale(ChangedPropertyFact propertyWrapper, String name, KnowledgeHelper drools) throws Exception {
        final JCRPropertyWrapper property = propertyWrapper.getProperty();
        final JCRSessionWrapper session = property.getSession();
        JCRNodeWrapper node = session.getNodeByIdentifier(property.getString());

        JCRNodeWrapper bannerNodeTrans = (JCRNodeWrapper) property.getParent();
        JCRNodeWrapper bannerNode = bannerNodeTrans.getParent();
        JCRNodeWrapper sliderNode = bannerNode.getParent();

        // Calculate needed with/height of the image
        int border = (int) sliderNode.getProperty("border").getLong();
        int width = (int) sliderNode.getProperty("width").getLong() - border*2;
        int height = (int) sliderNode.getProperty("height").getLong() - border*2;

        // Create a new image
        cropScale(new AddedNodeFact(node), bannerNode, name, width, height, session, drools);
    }

    private void cropScale(AddedNodeFact imageNode, JCRNodeWrapper bannerNode, String name, int width, int height, JCRSessionWrapper session, KnowledgeHelper drools) throws Exception {
        long timer = System.currentTimeMillis();

        // Crop the image

        if (this.isSmallerThan(imageNode.getNode(), width, height)) {
            logger.info("Selected image was smaller then required image of {}x{} not cropping this image",width,height);
        } else {
            JCRNodeWrapper newImage = crop(imageNode, "_iview", 0, 0, width, height, session, drools);
            if (newImage == null) {
                logger.warn("No cropped image was generated");
                return;
            }
            // Set the new image on the property
            JCRSessionWrapper bSession=bannerNode.getSession();
            bannerNode.setProperty(name, newImage);
            bSession.save();
        }

        if (logger.isDebugEnabled()) {
            logger.debug("crop for node {} created in {} ms", new Object[]{
                    imageNode.getNode().getPath(), System.currentTimeMillis() - timer});
        }
    }

    /**
     * Test if node is smaller or equal then width/height
     * @param node
     * @param width
     * @param height
     * @return
     */
    protected boolean isSmallerThan(JCRNodeWrapper node, int width, int height) {
        long iWidth = 0;
        long iHeight = 0;

        try {
            iWidth = node.getProperty("j:width").getLong();
            iHeight = node.getProperty("j:height").getLong();
        } catch (PathNotFoundException e) {
            // no size properties found
        } catch (RepositoryException e) {
            if (logger.isDebugEnabled()) {
                logger.warn("Error reading j:width/j:height properties on node " + node.getPath(),
                        e);
            } else {
                logger.warn("Error reading j:width/j:height properties on node " + node.getPath()
                        + ". Casue: " + e.getMessage());
            }
        }

        return iWidth > 0 && iHeight > 0 && iWidth <= width && iHeight <= height;
    }

    /**
     * Crop a given image within AddedNodeFact and create a new image with suffix
     * @param imageNode
     * @param suffix
     * @param top
     * @param left
     * @param width
     * @param height
     * @param session
     * @param drools
     * @return
     * @throws Exception
     */
    public JCRNodeWrapper crop(AddedNodeFact imageNode, String suffix, int top, int left, int width, int height, JCRSessionWrapper session, KnowledgeHelper drools) throws Exception {
        JCRNodeWrapper newImage=null;
        try {
            JCRNodeWrapper node = imageNode.getNode();

            // Get selected image
            Image image = getImageWrapper(imageNode, drools);
            if (image == null) {
                return null;
            }

            // get file's extension
            String fileExtension = FilenameUtils.getExtension(node.getName());
            if ((fileExtension != null) && (!"".equals(fileExtension))) {
                fileExtension = "." + fileExtension;
            }

            // Generate new filename
            String newFileName=FilenameUtils.removeExtension(node.getName()) + suffix + fileExtension;

            // Crop image
            File f = File.createTempFile(newFileName, fileExtension);
            imageService.cropImage(image, f, top, left, width, height);
            InputStream fis = new BufferedInputStream(new FileInputStream(f));
            try {
                JCRNodeWrapper dir=node.getParent();
                String ct=node.getFileContent().getContentType();

                // Remove old node if exists
                if (dir.hasNode(newFileName)) {
                    JCRNodeWrapper oldImage = dir.getNode(newFileName);
                    if (oldImage!=null) {
                        oldImage.remove();
                        dir.getSession().save();
                    }
                }

                // Save node and image
                newImage=dir.uploadFile(newFileName, fis, ct);
                session.save();

                // Continue drools
                AddedNodeFact thumbNode = new AddedNodeFact(newImage);
                drools.insert(thumbNode);
                JCRNodeWrapper contentNode = newImage.getNode(Constants.JCR_CONTENT);
                drools.insert(new ChangedPropertyFact(new AddedNodeFact(contentNode), Constants.JCR_DATA, f, drools));

            } finally {
                IOUtils.closeQuietly(fis);
                f.delete();
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return newImage;
    }

}
