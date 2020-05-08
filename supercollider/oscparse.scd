
thisProcess.openUDPPort(4545); // attempt to open 1121


(

// OSC PARSING


~maxobjects = 16;
~sustain = 1;

~o = Array.series(~maxobjects);

~x = ~o.collect{ Bus.control(s, 1) };
~y = ~o.collect{ Bus.control(s, 1) };
~w = ~o.collect{ Bus.control(s, 1) };
~h = ~o.collect{ Bus.control(s, 1) };
~c = ~o.collect{ Bus.control(s, 1) };
~g = ~o.collect{ Bus.control(s, 1) };

// x.do(arg val, i; val.set({rrand(0.0,1.0)}));
~num_people = Bus.control(s,1);
~num_vehicles = Bus.control(s,1);
~frame = Bus.control(s,1);
~num_rects = Bus.control(s,1);

// ~xArray = { var rects = ~num_rects.getSyncronous; (rects > 0.0).if({Array.fill(size: rects, function: {arg i; ~x[i].getSynchronous})},{Array.fill(1,{|i|i})}) };
~xArray = { Array.fill(size: ~num_rects.getSynchronous, function: {arg i; ~x[i].getSynchronous}) };

~yArray = { Array.fill(size: ~num_rects.getSynchronous, function: {arg i; ~y[i].getSynchronous}) };
~wArray = { Array.fill(size: ~num_rects.getSynchronous, function: {arg i; ~w[i].getSynchronous}) };
~hArray = { Array.fill(size: ~num_rects.getSynchronous, function: {arg i; ~h[i].getSynchronous}) };
~cArray = { Array.fill(size: ~num_rects.getSynchronous, function: {arg i; ~c[i].getSynchronous}) };

// ~objects = Dictionary.new;
)



(

OSCdef(\frame, {|msg|
	// ("Frame count: " ++ msg[1]).postln;
	~frame.set(msg[1]);
	}, "/frame_number"
		).permanent_(true);

OSCdef(\num_rects,{|msg, time|
	// ("Num rects: " ++ msg[1]).postln;
	~num_rects.set(msg[1]);
	(~sustain == 0).if({
		~g[msg[1]..].collect{|val|val.set(0)};
});
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
		// var n, x, y, w, h, c;

		/*n = msg[1];
		x = msg[2].linlin(0.0,1920.0,0.0,1.0);
		y = msg[3].linlin(0.0,1080.0,0.0,1.0);
		w = msg[4].linlin(0.0,1920.0,0.0,1.0);
		h = msg[5].linlin(0.0,1080.0,0.0,1.0);
		c = msg[6];*/

		~x[msg[1] - 1].set(msg[2].linlin(0.0,1920.0,0.0,1.0));
		~y[msg[1] - 1].set(msg[3].linlin(0.0,1080.0,0.0,1.0));
		~y[msg[1] - 1].set(msg[4].linlin(0.0,1920.0,0.0,1.0));
		~y[msg[1] - 1].set(msg[5].linlin(0.0,1080.0,0.0,1.0));
		~c[msg[1] - 1].set(msg[6]);
		~g[msg[1] - 1].set(1);



		/*(msg[1] == 1).if{
		~object1.set(msg[2].linlin(0.0,1920.0,0.0,1.0), msg[3].linlin(0.0,1080.0,0.0,1.0), msg[4].linlin(0.0,1920.0,0.0,1.0), msg[5].linlin(0.0,1080.0,0.0,1.0), msg[6])
			}*/

		/*~objects.put(msg[1] - 1, [ msg[2].linlin(0.0,1920.0,0.0,1.0), msg[3].linlin(0.0,1080.0,0.0,1.0), msg[4].linlin(0.0,1920.0,0.0,1.0), msg[5].linlin(0.0,1080.0,0.0,1.0), msg[6]])*/

		// ("objectno: " ++ n ++ " x: " ++ x ++ " y: " ++ y ++ " width: " ++ w ++ " height: " ++ h ++ " object type: " ++ c).postln

}, "/oxywhc").permanent_(true);
);


