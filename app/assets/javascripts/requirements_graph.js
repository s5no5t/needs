var needs = {

  renderer: function(canvas){
    var that = {};

    var ctx = canvas.getContext("2d");
    var gfx = arbor.Graphics(canvas);
    var particleSystem;

    that.init = function(system){
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
    };
      
    that.redraw = function(){
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
        ctx.fillStyle = "#ddd";
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.moveTo(pt1.x, pt1.y);
        ctx.lineTo(pt2.x, pt2.y);
        
        var draw_arrow = function(from, to){
            var headlen = 25;
            var angle = Math.atan2(to.y-from.y, to.x-from.x);
            ctx.moveTo(to.x, to.y);
            ctx.lineTo(to.x-headlen*Math.cos(angle-Math.PI/6),to.y-headlen*Math.sin(angle-Math.PI/6));
            ctx.lineTo(to.x-headlen*Math.cos(angle+Math.PI/6),to.y-headlen*Math.sin(angle+Math.PI/6));
            ctx.lineTo(to.x, to.y);
        };

        draw_arrow(pt1, pt2);
        ctx.fill();

        ctx.stroke();

      });

      particleSystem.eachNode(function(node, pt){
        // node: {mass:#, p:{x,y}, name:"", data:{}}
        // pt:   {x:#, y:#}  node position in screen coords
        var label = node.data.label || "";

        if (!node.data.orig_width || !node.data.orig_height){
          node.data.orig_width = ctx.measureText(label).width + 10;
          node.data.orig_height = 20;
          node.data.width = node.data.orig_width;
          node.data.height = node.data.orig_height;
        }

        if(node.data.width < 100) {
          node.data.width = 100;
        }
        if(node.data.height < 20) {
          node.data.height = 20;
        }

        var w = node.data.width;
        var h = node.data.height;

        pt.x = Math.floor(pt.x);
        pt.y = Math.floor(pt.y);

        ctx.fillStyle = "#555";
        //gfx.oval(pt.x-w/2, pt.y-w/2, w, w, {fill: ctx.fillStyle, alpha: 1.0})
        gfx.rect(pt.x-w/2, pt.y-h/2, w, h, 4, {fill: ctx.fillStyle, alpha: 1.0});

        ctx.font = "12px Helvetica";
        ctx.textAlign = "center";
        ctx.fillStyle = "white";
        ctx.fillText(label, pt.x, pt.y+4);
      });
    };

    that.initMouseHandling = function(){
      // no-nonsense drag and drop (thanks springy.js)
      var dragged_node = null, detailed_node = null, dragged_has_moved = false;

      $(canvas).mousedown(function(e){
        var pos = $(this).offset();
        var p = {x:e.pageX-pos.left, y:e.pageY-pos.top};
        var nearest = particleSystem.nearest(p);
        if (!nearest)
          return;

        dragged_node = nearest.node;
        dragged_node.fixed = true;
        dragged_has_moved = false;

        return false;
      });

      $(canvas).mousemove(function(e){
        var highlight_node = function(node){
          particleSystem.tweenNode(detailed_node, 0.5, {
            width: detailed_node.data.orig_width * 1.5,
            height: detailed_node.data.orig_height * 1.5
          });
        };

        var unhighlight_node = function(node){
          particleSystem.tweenNode(detailed_node, 0.5, {
            width: detailed_node.data.orig_width,
            height: detailed_node.data.orig_height
          });
        };

        if (dragged_node){
          var pos = $(this).offset();
          var p = {x:e.pageX-pos.left, y:e.pageY-pos.top};
          var s = particleSystem.fromScreen(p);
          dragged_node.p = {x:s.x, y:s.y};
          dragged_node.tempMass = 100;
          dragged_has_moved = true;
        }else{
          var pos = $(this).offset();
          var p = {x:e.pageX-pos.left, y:e.pageY-pos.top};
          var nearest = particleSystem.nearest(p);

          if (!nearest){
            if(detailed_node){
              highlight_node(detailed_node);
              detailed_node = null;
            }
            return;
          }

          if(detailed_node && detailed_node !== nearest.node){
            unhighlight_node(detailed_node);
          }

          if(detailed_node !== nearest.node){
            detailed_node = nearest.node;
            highlight_node(detailed_node);
          }
        }

        return false;
      });

      $(window).bind('mouseup', function(e){
        if (!dragged_node)
          return;

        if (!dragged_has_moved){
          var url = dragged_node.data.url;
          window.location.href = url;
        }

        dragged_node.fixed = false;
        dragged_node.tempMass = 100;
        dragged_node = null;

        return false;
      });
    };

    return that;
  },

  particleSystem: function(canvas){
    var sys = arbor.ParticleSystem(1000, 600, 0.5); // create the system with sensible repulsion/stiffness/friction
    sys.parameters({
      gravity: true, // use center-gravity to make the graph settle nicely (ymmv)
      stiffness: 1000
    });
    sys.renderer = needs.renderer(canvas); // our newly created renderer will have its .init() method called shortly by sys...
    return sys;
  }

};
