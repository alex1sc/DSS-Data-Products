<style>
  body {
    background-color: #96A2B6;
  }
</style>

eXtra Trees in Paris
========================================================
Alex Schmitt - 11 oct 2016


Goal of the application
========================================================

- Choose a tree regarding its caracteristics 
- Find it in Paris
- And choose another tree...

- Some more eXtra Trees in Jardin des Plantes
- And the possibility to choose the layout of the map...

- Technically the goal is to make plotly and leaflet communicate in shiny app :)

How to use the application
========================================================

- Just click on the top plot and a Special Marker will show up on the map below.
- Click on any other tree on the top plot and the Special Marker will show it.
- Change the layout of the map using the radio buttons on the left side bar.
- Or click on the last tab 'eXtra Trees' to find even more eXtra Trees in Jardin des Plantes in Paris :) not working on shiny server (: but you can find it here: http://www.mnhn.fr/sites/mnhn.fr/files/parcours/arbres_historiques_jardin_des_plantes.pdf


How it works
========================================================

- It's all automatic!
- Catching the clicked point in Plot.ly .
- Converting data from plot.ly to pass it to Leaflet using the same data frame.
- Redrawing Paris map with all the markers including the Special Marker.
- And choosing layout map from different data providers

- https://github.com/alex1sc/DSS-Data-Products for more information

Thanks
========================================================

