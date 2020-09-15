// SETUP AND BUFFERS

(

("finalsetupfile.scd").loadRelative;

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly ++ "samples/";

//// SAMPLES

// ~arnold = ~path ++ "waves/arnold/";
// ~arnold = PathName.new(~arnold);
// ~b_arnold = ~arnold.files.collect({|file| file.fullPath.postln; Buffer.read(s, file.fullPath)});
//
//
// ~random = ~path ++ "ogg/";
// ~random = PathName.new(~random);
// ~b_random = ~random.files.collect({|file| file.fullPath.postln; Buffer.readChannel(s, file.fullPath,channels: [0])});
//
//
// ~anthem = ~path ++ "anthemogg/";
// ~anthem = PathName.new(~anthem);
// ~b_anthem = ~anthem.files.collect({|file| file.fullPath.postln; Buffer.readChannel(s, file.fullPath,channels: [0])});


);

// PHASE MODULATION

Ndef(\pmosc, {
			var numVoices = 8;
			var sig;



			sig = Array.fill(numVoices, {
				|i|
				var pmosc;
				var points = 7;
				var ienv = Env.new({Rand(0.01,1)} ! points, ({Rand(0.01,1)} ! (points - 1)).normalizeSum, {Rand(-6,6)} ! (points - 1));
				var xx = IEnvGen.kr(ienv, ~x[i].kr);
				var yy = IEnvGen.kr(ienv, ~y[i].kr);

				pmosc = PMOsc.ar(carfreq: xx.linlin(0,1,50,800), modfreq: yy.linlin(0,1,50,800), pmindex: (~x[i].kr + ~y[i].kr / 2 ).linlin(0,1,0,5), modphase: 0);


				pmosc = pmosc * ~sus[i].kr.lag(1) * 0.3;

				Pan2.ar(pmosc,LFNoise2.kr(0.2));
			});

			Out.ar([0,1],sig)

});



Ndef(\sweepsin, {
			var numVoices = 8;
			var sig;

			sig = Array.fill(numVoices, {
				|i|
				var trig = Dust.kr(~x[i].kr.linlin(0,1,0.5,10));
				var points = 7;
				var ienv = Env.new({Rand(0.01,1)} ! points, ({Rand(0.01,1)} ! (points - 1)).normalizeSum, {Rand(-6,6)} ! (points - 1));
				var sin = SinOsc.ar(IEnvGen.kr(ienv, (~x[i].kr.lag(1) + ~y[i].kr.lag(1)) / 2).linexp(0,1,60,1200).round(60) * Sweep.kr(trig, LFNoise2.kr(0.2).range(5,20))).cubed;

				sin * ~sus[i].kr.lag(1) * 0.3;
			});

			sig = Splay.ar(sig, 0.3);

			Out.ar([0,1],sig);
});


Ndef(\sinfreak, {
			var numVoices = 8;
			var sig, sus, env;

			sig = Array.fill(numVoices, {|i|
				var sig;
				var points = 7;
				var ienv = Env.new({Rand(0.01,1)} ! points, ({Rand(0.01,1)} ! (points - 1)).normalizeSum, {Rand(-6,6)} ! (points - 1));
				var xx = IEnvGen.kr(ienv, ~x[i].kr);
				var yy = IEnvGen.kr(ienv, ~x[i].kr);

				sig = SinOsc.ar(~x[i].kr().range(200,3000).round(50).lag(1));
				sig = Pan2.ar(sig, ~area[0].kr.linlin(0,1,1,-1));
				sig = DelayC.ar(sig, ~x[i].kr.range(0.1,2),~y[i].kr().lag(0.4).exprange(0.1,2));
				sig = sig * ~sus[i].kr;
			});

			sig = FreeVerb.ar(sig, mix: LFNoise2.kr(0.2).linexp(-1,1,0.1,0.9),room: ~x[1].kr.lag(1).range(0.01,1),damp: 1);

			Out.ar([0,1], sig * 0.4);

		}
);


Ndef(\formula, {
	var numVoices = 8;
	var freqs, sustains, feedbacks, sinfreq;

	var sig = Array.fill(numVoices, {
		|i|
		var points = 7;
		var ienv = Env.new({Rand(0.01,1)} ! points, ({Rand(0.01,1)} ! (points - 1)).normalizeSum, {Rand(-6,6)} ! (points - 1));
		var xx = IEnvGen.kr(ienv, ~x[i].kr).exprange(50,1000).round(12.5).lag(1);
		var yy = IEnvGen.kr(ienv, ~y[i].kr);

		var sig = SinOscFB.ar( (xx * Demand.kr(Dust.kr(~x[i].kr.linexp(0,1,1,30)),0,Dwrand([1,2,3], [0.8,0.1,0.1],inf))).lag(1), yy.lag(1));
		sig = Pan2.ar(sig, LFNoise2.kr(0.2));
		sig * ~sus[i].kr * 0.5;
	});



	Out.ar([0,1], sig);


});

Ndef(\weird, {
		var numVoices = 8;
		var sig;


		sig = Array.fill(numVoices, {
			|i|
			var env;
			var pmosc;
			pmosc = PMOsc.ar(carfreq: ~x[i].kr.range(50,400), modfreq: ~y[i].kr.range(50,400), pmindex: LFNoise2.kr(0.3).range(0,5), modphase: 0);
			pmosc = CombN.ar(pmosc, 10, 2 * LFNoise1.kr((~x[i].kr.lag(1) + ~y[i].kr.lag(1) / 2 ).linlin(0,1,5,40)).range(0.01,2),0.01);
			pmosc = pmosc * ~sus[i].kr.lag(1) * 0.3;
			Pan2.ar(pmosc, Hasher.kr(~y[i].kr).lag(4));

			});

			// sig = CombN.ar(sig, 10, 2 * LFNoise1.kr(40).range(0.01,2), 0.01);
			sig = Splay.ar(sig, 0);
			Out.ar(0,sig);
});




		Ndef(\anthem, {
	var numObjects = 8;
	var buffolder = ~b_anthem;
	var sig, buffer, env;
	var trigger;

	buffolder = buffolder.scramble;

	sig = Array.fill(numObjects,{|i|
		var points = 7;
		var ienv = Env.new({Rand(0.01,1)} ! points, ({Rand(0.01,1)} ! (points - 1)).normalizeSum, {Rand(-6,6)} ! (points - 1));
		var xx = IEnvGen.kr(ienv, ~x[i].kr);
		var yy = IEnvGen.kr(ienv, ~y[i].kr);

		var trig = Impulse.kr(0.12);
		var seq = Drand(buffolder, inf);
		var buf = Demand.kr(trig, 0, seq);

		/*var buf = buffolder[i];*/
		var rate = xx.lag(1).linlin(0,1,0,2);
		var pan = yy.lag(1).linlin(0,1,-1,1);
		// var pan = 0;
		var amp = ~sus[i].kr.lag(0) * 1;
		var sig = PlayBuf.ar(numChannels: 1 , bufnum: buf, rate: BufRateScale.kr(buf) * rate, trigger: 1,startPos: 0 ,loop: 1,doneAction: 0);

		Pan2.ar(sig, pan, amp * 2);
	});
	// sig = PitchShift.ar(sig, 0.2, 1, 1, 0.3);

	sig = Pan2.ar(sig, 0);
	Out.ar([0,1],sig);
});



Ndef(\sinFBsinFB, {

	var numVoices = 8;

	var sig = Array.fill(numVoices, {
		|i|
		var points = 5;
		var ienv = Env.new({Rand(0.01,1)} ! points, ({Rand(0.01,1)} ! (points - 1)).normalizeSum, {Rand(-6,6)} ! (points - 1));
		var xx = IEnvGen.kr(ienv, ~x[i].kr);
		var yy = IEnvGen.kr(ienv, ~y[i].kr);
		var trig = Impulse.kr(xx.linlin(0,1,1,8));

		var sig = SinOscFB.ar(xx.exprange(30,600), yy.lag(0.2)) * ( SinOsc.ar(yy.exprange(30,1200)) * yy.lag(0.51));

		sig = sig * EnvGen.kr(Env.perc(0.05,0.2), trig) * ~sus[i].kr.lag(1) * 0.8;


		sig;



	});
	sig = Pan2.ar(sig, 0);
	Out.ar([0,1], sig);
});
