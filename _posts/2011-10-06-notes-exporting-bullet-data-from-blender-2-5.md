---
id: 4571
title: 'Notes: Exporting .bullet data from Blender 2.5'
date: 2011-10-06T12:48:40+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4571
permalink: /2011/10/06/notes-exporting-bullet-data-from-blender-2-5/
categories:
  - Alone, The
  - Technobabble
---
Here&#8217;s some notes from my internal wiki.

How to export .bullet data from a Blender 2.5x scene (awfully close to 2.6 now &#8216;eh). This might be as of Blender 2.57, and should continue to work well in to 2.6x.

> ## Exporting Bullet Data from Blender
> 
> Exporting Bullet Physics data from Blender is a pain in the ass. Plain and Simple. It \*SHOULD\* be a right click export, but no, it&#8217;s complicated.
> 
> 1. Switch to Game Engine Mode (In the Title Bar, the default setting is &#8220;Blender Render&#8221;. Should be &#8220;Blender Game&#8221;).
    
> 2. Game Engine Mode changes the \*Physics\* Properties (bouncing ball)
      
> * Make the Physics Type a &#8220;Rigid Body&#8221;
      
> * Enable Collision Bounds, and pick a bounding volume type (boxes, hulls)
      
> * To make compound objects, you need to treat one object as the parent, and check the compound buttons
      
> \* Under the \*Object* Properties (tiny cube), Relations Parent can be used to identify oneself as a child of a parent
      
> * Defining compound objects is required to make overlapping volumes that don&#8217;t affect each-other.
    
> 3. Change a pane to a \*Logic Editor\* (little red-ball joystick)
    
> 4. Add a &#8220;Keyboard&#8221; sensor, and set the key to the spacebar (for example&#8230; we&#8217;re binding the spacebar to an action)
    
> 5. Add a &#8220;Python&#8221; controller
    
> 6. Change a pane to a \*Text Editor\*
    
> 7. Hit + to create an instance (default name is &#8220;text&#8221;)
    
> 8. Paste the following script in to the text editor
> 
> <pre>import bpy;
import PhysicsConstraints;
print( "Exporting..." );
PhysicsConstraints.exportBulletFile( bpy.path.ensure_ext(bpy.data.filepath,".bullet") );</pre>
> 
> 9. Update the &#8220;Python&#8221; controller to use this script file
    
> 10. Drag a link between the Keyboard sensor and the python controller (see the little nodes between them)
    
> 11. If you haven&#8217;t already, save the .blend file. <del>If you close Blender, then double click on the saved .blend file, it will change the current working directory of Blender. This is important, because the script above (with no path) saves the .bullet file to the working directory.</del>
    
> 12. Finally, to generate the blend file, run the simulation (R key).
    
> 13. To export, while the simulation is running, push the spacebar.
    
> 14. The console will show the &#8220;Exporting&#8230;&#8221; message. If you don&#8217;t have a blender console, you can enable it under **Help->Toggle Blender Console**
> 
> Done. That&#8217;s the annoying way to export .bullet data from blender.
> 
> The reason for the complicated procedure is that the PhysicsConstraints and bge libraries are just not available in standard plugin scope. Right clicking and running the script, just not an option. So we need to enter a game instance, where all these helpful library instances exist (as otherwise you wouldn&#8217;t have physics).
> 
> Research conducted on October 6th, 2011, using Blender 2.59.
> 
> ### References
> 
> http://www.blender.org/documentation/blender\_python\_api\_2\_59_3/bpy.path.html
> 
> http://bulletphysics.org/Bullet/phpBB3/viewtopic.php?f=9&t=6683&p=23315#p23315
> 
> http://wiki.blender.org/index.php/Doc:2.5/Manual