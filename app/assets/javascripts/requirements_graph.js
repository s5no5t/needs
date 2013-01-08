$(function(){

  var Renderer = function(canvas){
    var ctx = canvas.getContext("2d");
    var gfx = arbor.Graphics(canvas);
    var particleSystem;

    var that = {
      init: function(system){
        //
        // the particle system will call the init function once, right before the
        // first frame is to be drawn. it's a good place to set up the canvas and
        // to pass the canvas size to the particle system
        //
        // save a reference to the particle system for use in the .redraw() loop
        particleSystem = system;

        // inform the system of the screen dimensions so it can map coords for us.
        // if the canvas is ever resized, screenSize should be called again with
        // the new dimensions
        particleSystem.screenSize(canvas.width, canvas.height);
        
        // set up some event handlers to allow for node-dragging
        that.initMouseHandling();
      },
      
      redraw: function(){
        // 
        // redraw will be called repeatedly during the run whenever the node positions
        // change. the new positions for the nodes can be accessed by looking at the
        // .p attribute of a given node. however the p.x & p.y values are in the coordinates
        // of the particle system rather than the screen. you can either map them to
        // the screen yourself, or use the convenience iterators .eachNode (and .eachEdge)
        // which allow you to step through the actual node objects but also pass an
        // x,y point in the screen's coordinate system
        // 
        ctx.fillStyle = "white";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        particleSystem.eachEdge(function(edge, pt1, pt2){
          // edge: {source:Node, target:Node, length:#, data:{}}
          // pt1:  {x:#, y:#}  source position in screen coords
          // pt2:  {x:#, y:#}  target position in screen coords

          // draw a line from pt1 to pt2
          ctx.strokeStyle = "rgba(0,0,0, .333)";
          ctx.lineWidth = 1;
          ctx.beginPath();
          ctx.moveTo(pt1.x, pt1.y);
          ctx.lineTo(pt2.x, pt2.y);
          ctx.stroke();
        });

        particleSystem.eachNode(function(node, pt){
          // node: {mass:#, p:{x,y}, name:"", data:{}}
          // pt:   {x:#, y:#}  node position in screen coords
          var radius = 30;
          var label = node.data.label || "";
          var w = ctx.measureText(label).width + 10;

          if(w < radius) {
            w = radius;
          }
          pt.x = Math.floor(pt.x);
          pt.y = Math.floor(pt.y);

          ctx.fillStyle = "black";
          //gfx.oval(pt.x-w/2, pt.y-w/2, w, w, {fill: ctx.fillStyle, alpha: 1.0})
          gfx.rect(pt.x-w/2, pt.y-10, w, 20, 4, {fill: ctx.fillStyle, alpha: 1.0});

          ctx.font = "12px Helvetica";
          ctx.textAlign = "center";
          ctx.fillStyle = "white";
          ctx.fillText(label, pt.x, pt.y+4);
        });
      },

      initMouseHandling: function(){
        // no-nonsense drag and drop (thanks springy.js)
        var dragged = null;

        $(canvas).mousedown(function(e){
          var pos = $(this).offset();
          var p = {x:e.pageX-pos.left, y:e.pageY-pos.top};
          var nearest = particleSystem.nearest(p);
          if (!nearest)
            return;

          dragged = nearest;
          dragged.node.fixed = true;

          return false;
        });

        $(canvas).mousemove(function(e){
          if (dragged !== null && dragged.node !== null){
            var pos = $(this).offset();
            var p = {x:e.pageX-pos.left, y:e.pageY-pos.top};
            var s = particleSystem.fromScreen(p);
            dragged.node.p = {x:s.x, y:s.y};
            dragged.node.tempMass = 100;
          }

          return false;
        });

        $(window).bind('mouseup', function(e){
          if (dragged===null || dragged.node===undefined)
            return;

          dragged.node.fixed = false;
          dragged.node.tempMass = 100;
          dragged = null;

          return false;
        });
      }

    };
    
    return that;
  };

  var canvas = $("#viewport").get(0);
  var sys = arbor.ParticleSystem(1000, 600, 0.5) // create the system with sensible repulsion/stiffness/friction
  sys.parameters({
    gravity: true, // use center-gravity to make the graph settle nicely (ymmv)
    stiffness: 1000
  });
  sys.renderer = Renderer(canvas); // our newly created renderer will have its .init() method called shortly by sys...

  $.getJSON("/requirements", function(data){
    var req, derived_reqs, derived_req, found;

    for(var i=0; i<data.length; i++){

      req = data[i].requirement;

      sys.addNode(req.id.toString(), {
        label: req.id.toString()
      });

      derived_reqs = req.derived_requirements;

      for(var j=0; j<derived_reqs.length; j++){
        derived_req = derived_reqs[j].derived_requirement;

        found = false;
        for(var k=0; k<data.length; k++){
          if(data[k].requirement.id === derived_req.id){
            found = true;
          }
        }

        if (found){
          sys.addEdge(req.id.toString(), derived_req.id.toString());
        }

      }

    }
  });

});
