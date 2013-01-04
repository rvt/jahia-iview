jahia-iview
===========

Jahia module for the iView jQuery slider
Please see http://iprodev.com/2012/07/iview/ for detail and demo of this slider

Installation
============

Create a war archive using the following command:

mvn package

Copy the generated war archive into your Jahia's shared_modules folder.
This installation requires a restart because of a added library.

Oddities
========
The way the iView slider works doesn't allow to properly match the prev/next buttons
based on the correct 'skin'. It is at this moment possible to select a skin/prev/next
combination that doesn't look good. It does however split the skins from 5 skins to 7 skins,
but cautions must be taken for this type of selection.
Portions could be solved within this module, but it would possible require modifications to the iview.js file,
something I didn't want to do because of upgrade and beable to do this easely.



TODO
====

1) Re-create iview images when slider width/height/border size changes
Background:  This module does re-generate new images based on the requested slider width/height and border size. Howeverm when you change any of these paraemeters
the new image sizes are not re-generated and a user must re-select the image. THis needs to get solved by re-generating all images when any of the width/height/border
parameters changes.



Please consider this module as beta and feedback is appreciated!
R. van Twisk rvt_irclogs@rvt.dds.nl