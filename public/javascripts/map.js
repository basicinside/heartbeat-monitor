var nodesLayer, linksLayer;
var hashNodes = {};
var measurePopup;
var feature;
var popup;
var map;

var zoom = 16;

var linkColors = [
  '#FF0000', // 0
  '#FF3300', // 10
  '#FF6600', // 20
  '#FF9900', // 30
  '#FFCC00', // 40
  '#FFFF00', // 50
  '#FFCC00', // 60
  '#CCFF00', // 70
  '#99FF00', // 80
  '#66FF00', // 90 
  '#00FF00', // 100
];

var linkWidths = [
  '3', // 0
  '3', // 10
  '3', // 20
  '3', // 30
  '4', // 40
  '4', // 50
  '4', // 60
  '4', // 70
  '5', // 80
  '5', // 90 
  '5', // 100
];


function map() {
	map = new OpenLayers.Map('fullmap', {
		maxExtent : new OpenLayers.Bounds(-20037508.34, -20037508.34,
				20037508.34, 20037508.34),
		numZoomLevels : 21,
		maxResolution : 156543.0399,
		units : 'm',
		projection : new OpenLayers.Projection("EPSG:900913"),
		displayProjection : new OpenLayers.Projection("EPSG:4326")
	});

	var osm = new OpenLayers.Layer.OSM();

	/* Nodes */
	nodesLayer = new OpenLayers.Layer.Vector("Nodes", {
		styleMap : new OpenLayers.StyleMap({
			strokeColor : '${borderColor}',
			strokeWidth : '${width}',
			graphicZIndex : "${zIndex}",
			pointRadius : "5px",
			fillColor : "${color}",
			fillOpacity : 0.70
		}),
		rendererOptions : {
			zIndexing : true
		}
	});

	// load Nodes
	for ( var i = 0; i < nodes.length; i++) {
		console.log(nodes[i].name);
		hashNodes[nodes[i].id] = nodes[i];
		var feature = new OpenLayers.Feature.Vector(
				new OpenLayers.Geometry.Point(nodes[i].lon, nodes[i].lat)
						.transform(new OpenLayers.Projection("EPSG:4326"),
								new OpenLayers.Projection("EPSG:900913")));
		feature.attributes.color = '#11CC44';
		feature.node = nodes[i];
		feature.attributes.borderColor = '#222';
		nodesLayer.addFeatures(feature);
	}

	nodesLayer.events.on({
		"featureselected" : onSelect,
		"featureunselected" : onUnselect
	});


	/* Links */
	linksLayer = new OpenLayers.Layer.Vector('rpLinks', {
		styleMap : new OpenLayers.StyleMap({
			strokeColor : '${color}',
			strokeWidth : '${width}',
			strokeOpacity : 1,
			fillColor : '${color}',
			fillOpacity : 0.5
		})
	});

	// load Links
	for ( var i = 0; i < links.length; i++) {
		if (hashNodes[links[i].from] && hashNodes[links[i].to]) {
      var mlat = (parseFloat(hashNodes[links[i].from].lat) + parseFloat(hashNodes[links[i].to].lat)) / 2;
      var mlon = (parseFloat(hashNodes[links[i].from].lon) + parseFloat(hashNodes[links[i].to].lon)) / 2;
			var ls = new OpenLayers.Geometry.LineString([
					new OpenLayers.Geometry.Point(hashNodes[links[i].from].lon,
							hashNodes[links[i].from].lat).transform(
							new OpenLayers.Projection("EPSG:4326"),
							new OpenLayers.Projection("EPSG:900913")),
					new OpenLayers.Geometry.Point(mlon,mlat).transform(
							new OpenLayers.Projection("EPSG:4326"),
							new OpenLayers.Projection("EPSG:900913")) ]);
			var ls2 = new OpenLayers.Geometry.LineString([
					new OpenLayers.Geometry.Point(mlon, mlat).transform(
							new OpenLayers.Projection("EPSG:4326"),
							new OpenLayers.Projection("EPSG:900913")),
					new OpenLayers.Geometry.Point(hashNodes[links[i].to].lon,
							hashNodes[links[i].to].lat).transform(
							new OpenLayers.Projection("EPSG:4326"),
							new OpenLayers.Projection("EPSG:900913")) ]);
			var feature = new OpenLayers.Feature.Vector(ls, null);
			var feature2 = new OpenLayers.Feature.Vector(ls2, null);
      /* */
      feature.link = links[i];
			feature.attributes.color = linkColors[Math.floor(parseFloat(links[i].lq) * 10)];
			feature.attributes.width = linkWidths[Math.floor(parseFloat(links[i].lq) * 10)];
			linksLayer.addFeatures(feature);

			feature2.attributes.color = linkColors[Math.floor(parseFloat(links[i].nlq) * 10)];
			feature2.attributes.width = linkWidths[Math.floor(parseFloat(links[i].nlq) * 10)];
      feature2.link = links[i];
			linksLayer.addFeatures(feature2);
      /* 
      feature.attributes.color = linkColors[1];
      feature.attributes.width = 10;
			linksLayer.addFeatures(feature); */
		}
	}

	linksLayer.events.on({
		"featureselected" : onSelect,
		"featureunselected" : onUnselect
	});

	/* Control Panel */
	var p = new OpenLayers.Control.Panel({
		'displayClass' : 'olControlEditingToolbar'
	});
	// map.addControl(new OpenLayers.Control.LayerSwitcher());

	var control = new OpenLayers.Control.SelectFeature([nodesLayer, linksLayer], {
		displayClass : 'olControlDrawFeaturePoint'
	});

	var m = new OpenLayers.Control.Measure(OpenLayers.Handler.Path, {
		displayClass : 'olControlDrawFeaturePath',
		geodesic : true
	});
	m.events.on({
		"measure" : onClickMeasure,
		"measurepartial" : onClickMeasure
	});

	map.addControl(p);
	p.addControls([ new OpenLayers.Control.Navigation(), control, m ]);

	map.addLayers([ osm, linksLayer, nodesLayer ]);

	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			lat = position.coords.latitude;
			lon = position.coords.longitude;
			var lonLat = new OpenLayers.LonLat(lon, lat).transform(
					map.displayProjection, map.projection);
			map.setCenter(lonLat, zoom);
		});
	} else {
		var lonLat = new OpenLayers.LonLat(13.483937263488770,
				52.562709808349609).transform(map.displayProjection,
				map.projection);
		map.setCenter(lonLat, zoom);
	}

	map
			.addControls([ new OpenLayers.Control.Navigation(),
					new OpenLayers.Control.ZoomIn(),
					new OpenLayers.Control.ZoomOut() ]);
  control.activate();

}

function onSelect(evt) {
	feature = evt.feature;
  if (feature.node) {
  if (feature.node.ipv4)
    var content = "<a href='http://" + feature.node.ipv4 + "'>" + feature.node.name + "</a>";
  else
    var content = feature.node.name;
	popup = new OpenLayers.Popup.FramedCloud("featurePopup", feature.geometry
			.getBounds().getCenterLonLat(), new OpenLayers.Size(120, 100),
			content, null, true, onUnselect);
  }
  else {
	popup = new OpenLayers.Popup.FramedCloud("featurePopup", feature.geometry
			.getBounds().getCenterLonLat(), new OpenLayers.Size(120, 100),
			hashNodes[feature.link.from].name + " (" + feature.link.lq + 
      ") <--> " + hashNodes[feature.link.to].name + "(" + feature.link.nlq + ")" , 
                                            null, true, onUnselect);
  }
	map.addPopup(popup);
}

function onUnselect(evt) {
    if (popup)
		  map.removePopup(popup);
    popup = null;
}

function onClickMeasure(event) {
	if (measurePopup)
		measurePopup.hide();
	var units = event.units;
	var measure = event.measure;
	measurePopup = new OpenLayers.Popup.FramedCloud("featurePopup",
			event.geometry.getBounds().getCenterLonLat(), new OpenLayers.Size(
					120, 100), "<b>Distanz</b><br />" + measure.toFixed(3)
					+ units, null, true, function() {
				measurePopup.hide();
			});
	map.addPopup(measurePopup);
}
