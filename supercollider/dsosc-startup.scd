(

//increase number of buffers the server has access to for loading samples
 s.options.numBuffers = 1024 * 16;
 //increase the memory available to the server
 s.options.memSize = 8192 * 64;
 //boot the server
 s.boot;
 //display the oscilloscope
 // s.scope;
 //start proxyspace
// p=ProxySpace.push(s);


thisProcess.openUDPPort(4545); // attempt to open 4545
thisProcess.openPorts;



// OSC PARSING


~maxobjects = 32;
~sustain = 0;

~o = Array.series(~maxobjects);

~x = ~o.collect{ Bus.control(s, 1) };
~y = ~o.collect{ Bus.control(s, 1) };
/*~w = ~o.collect{ Bus.control(s, 1) };
~h = ~o.collect{ Bus.control(s, 1) };*/
~area = ~o.collect{ Bus.control(s, 1) };
~class = ~o.collect{ Bus.control(s, 1) };
~sus = ~o.collect{ Bus.control(s, 1) };


~xavg = Bus.control(s,1);
~yavg = Bus.control(s,1);
~wavg = Bus.control(s,1);
~havg = Bus.control(s,1);

~num_people = Bus.control(s,1);
~num_vehicles = Bus.control(s,1);
~frame = Bus.control(s,1);
~num_rects = Bus.control(s,1);






OSCdef(\frame, {|msg|
	~frame.set(msg[1]);
	// msg[1].postln;

	// ("Frame count: " ++ msg[1]).postln;

	}, "/frame_number"
		).permanent_(true);

/*OSCdef(\num_rects,{|msg, time|
	// ("Num rects: " ++ msg[1]).postln;

~num_rects.set(msg[1]);

if (~sustain == 0, {
~g[msg[1]..].collect{|val|val.set(0)};

});
}, "/num_rects").permanent_(true);*/


OSCdef(\num_rects,{|msg, time|
	// ("Num rects: " ++ msg[1]).postln;

	~num_rects.set(msg[1]);

	if(~sustain == 0, {~sus[msg[1]..].collect{|val|val.set(0)}; });

	if ( msg[1] != 0 and: {msg[1] <= ~maxobjects } , {

		var xAvg, xArray, yAvg, yArray, wAvg, wArray, hAvg, hArray;

		xArray = { Array.fill(size:msg[1], function: {arg i;  ~x[i].getSynchronous}) }.value;
		yArray =  { Array.fill(size:msg[1], function: {arg i; ~y[i].getSynchronous}) }.value;
		/*wArray =  { Array.fill(size:msg[1], function: {arg i; ~w[i].getSynchronous}) }.value;
		hArray =  { Array.fill(size:msg[1], function: {arg i; ~h[i].getSynchronous}) }.value;
*/
		xAvg = (xArray.sum / xArray.size);
		yAvg = (yArray.sum / yArray.size);
/*		wAvg = (~wArray.sum / ~wArray.size);
		hAvg = (~hArray.sum / ~hArray.size);*/


		/*("Num rects: " ++ msg[1]).postln;
		("xavg: " ++ xAvg).postln;
		("yavg: " ++ yAvg).postln;*/


		~xavg.set(xAvg);
		~yavg.set(yAvg);
	/*	~wavg.set(wAvg);
		~havg.set(hAvg);*/

	}, {"false"} );




}, "/num_rects").permanent_(true);

OSCdef(\num_people, {|msg|
// ("Frame count: " ++ msg[1]).postln;
~num_people.set(msg[1]);
}, "/num_people"
).permanent_(true);

OSCdef(\num_vehicles, {|msg|
// ("Number of vehicles:" ++ msg[1]).postln;
~num_vehicles.set(msg[1]);
}, "/num_vehicles"
).permanent_(true);

OSCdef(\oxywhc,
	{
		arg msg, time;

		~x[msg[1] ].set(msg[2].linlin(0.0,1920.0,0.0,1.0));
		~y[msg[1] ].set(msg[3].linlin(0.0,1080.0,0.0,1.0));
/*		~w[msg[1] ].set(msg[4].linlin(0.0,1920.0,0.0,1.0));
		~h[msg[1] ].set(msg[5].linlin(0.0,1080.0,0.0,1.0));*/
		~area[msg[1]].set(msg[4].linlin(0.0,1920.0,0.0,1.0) * msg[5].linlin(0.0,1080.0,0.0,1.0));
		~class[msg[1] ].set(msg[6]);
		// msg.postln;
		~sus[msg[1] ].set(1);

		// ("objectno: " ++ n ++ " x: " ++ x ++ " y: " ++ y ++ " width: " ++ w ++ " height: " ++ h ++ " object type: " ++ c).postln

}, "/oxywhc").permanent_(true);

);


