<h1>An HTML / Javascript program for browsing large sets of GPS tagged images from phones or Unmanned Aerial Vehicles, on a map.</h1>

<p><b>This is my first attempt to clone a repo in GitHub. Thanks to Matthias Wandel for sharing this code.</b></p>

<p>Matthias Wandel has a video about his version here: <a href="https://youtu.be/D-l51PBAx4I" target="_blank">https://youtu.be/D-l51PBAx4I</a></p>

<p>You can <a href="https://woodgears.ca/gpspix/index.html" target="_blank"><b>Try it out here</b></a></p>

<p>I like how phones and drones can show heatmaps of where photos were taken on a map, but my photo collection on my PC encompasses photos from many devices. Matthias wanted to be able to browse photos by location on his PC and so do I, so he created this program. He started by challenging AI (Google Gemini) to write such a program. Over several months he refined it and added features, mostly by requesting specific changes to the code and inspecting and tweaking the resulting code.</p>

<p>The program is intended to be run locally on your computer. Keep <code>gps.html</code> and <code>gathergps.html</code> together in one folder of your own; they do <b>not</b> need to be copied into your photo collection. The only file that goes into the root directory of your photo collection is <code>gpstagged.txt</code>.</p>

<p>Scanning thousands of files every time <code>gps.html</code> is opened would take very long. Instead, <code>gps.html</code> loads a file <code>gpstagged.txt</code> containing pre-gathered metadata for all images. This file is created by <code>gathergps.html</code>. Due to various security limitations of HTML / JavaScript, <code>gathergps.html</code> needs you to browse to the root of your image tree. In Chrome or Edge it saves <code>gpstagged.txt</code> straight into that folder. Then open <code>gps.html?folder</code>, or just <code>gps.html</code> if there is no <code>gpstagged.txt</code> next to it, and choose the same photo folder when asked: <code>gps.html</code> reads the index and the photos through that folder. Recently used folders are listed so that next time it takes one click. The <b>Change folder</b> button switches to another collection.</p>

<p>In other browsers (Firefox), <code>gathergps.html</code> puts <code>gpstagged.txt</code> in your downloads folder, and you have to use the older method: move it to the root of the photo directory and also put <code>gps.html</code> there, then open that copy. That older method also still works in Chrome and Edge.</p>

<p><b>Windows:</b> <code>GPSpix-Launcher.bat</code> does all of this for you. It asks for the photo folder, runs the scan, and opens the map, without copying any HTML files.</p>

<p>For his photo collection of 160,000 photos, only 10% have GPS coordinates, and he uses a script <code>gathergps.py</code>, but this Python script assumes the files are organized the way they are on his computer.</p>

<hr>

<h3>Typical view of GPSpix</h3>
<p><img src="pix/view1.webp" alt="Typical view of GPSpix map interface"></p>
<p><small>Map data from <a href="https://www.openstreetmap.org" target="_blank">OpenStreetMap</a></small></p>

<p>The large light blue circle on this view represents several thousand images at a camp. Unfortunately, phones will often use a guess for the Latitude / Longitude coordinates if they don't have a GPS fix when a photo was taken. This guess is often based on the current cell tower and cell sector that the phone is connected to, which can be several kilometers off. The circles towards the top left on the above map are mostly guesses. In his experience, iPhones are much less likely to just use a guess for Lat/Lon.</p>

<p>If you are taking photos and want to make sure they have proper coordinates, you can open your maps app beforehand to ensure the phone gets a fix, as it will try harder to get a fix while in maps. Alternatively, you can tell the phone to navigate somewhere, at which point it will do its best to maintain a GPS fix even with maps running in the background.</p>

<p>Images can be selected by clicking on them with a mouse. Pan and zoom are done by dragging the map or rolling the mouse wheel. You can also pinch in and out on mobile.</p>

<p>Large clusters of images will resolve into smaller clusters and eventually individual images as you zoom in on them.</p>

<p>At the top left of the map view is a scale bar indicating the map scale, plus a button to switch the background  view on Google Maps and back to Satellite.</p>

<hr>

<h3>Zoomed in on just a few days</h3>
<p><img src="pix/time-zoomed.webp" alt="Zoomed in time scale and histogram view"></p>

<p>Below the scale bar is a time scale and histogram of when images were taken. You can drag the green sliders on the time scale to limit the images shown to a certain time range. You can also zoom in on the time scale between the markers using the "time zoom in" button. By successively zooming in, you can zoom the time scale to just a few days.</p>
<hr>

<h3>Altitude Slider</h3>
<p><img src="pix/altitude-slider.webp" alt="Altitude slider interface"></p>

<p>There is also an altitude slider on the side of the map view. You can use this slider to filter and restrict displayed photos based on their altitude or elevation above sea level. This is especially useful for filtering out high-altitude or low-altitude data points when reviewing aerial or drone imagery.</p>

<p>Once you have moved the green pointers inward, an <b>altitude zoom in</b> button appears above the slider. It stretches the altitude scale so the range between the pointers fills the slider, which makes fine adjustments easy; the same button then becomes <b>altitude zoom out</b>. <b>Reset altitude</b> removes the filter and returns to the automatic scale. These work like the <b>time zoom in</b> and <b>Reset timeline</b> buttons on the time scale.</p>

<hr>

<h3>Selection Window & Selected Photos</h3>
<p><img src="pix/selection-window.webp" alt="Selection window interface"></p>

<p>You can use the selection window feature to draw a bounding box or select a specific area directly on the map. This instantly filters and isolates the displayed photos to only those taken within your drawn boundary, making it easy to examine a specific region in detail.</p>

<p>When you select specific photo dots on the map, they are highlighted to help you review their exact coordinates and metadata. If you press the <b>Delete</b> or <b>Backspace</b> key on your keyboard while items are selected, those items are cleared and hidden from your active view. This allows you to quickly filter out clutter or dismiss specific locations from your session without affecting the actual image files stored on your PC.</p>
