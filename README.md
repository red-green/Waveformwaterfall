# Waveformwaterfall
Processing program that shows a scrolling waveform with constituent colors corresponding to different frequencies on a roughly logarithmic scale

This program emerged out of a desire to see a live representation of the surrounding audio in a style similar to the previews you may see in DJ apps (case in point: djay). It uses an FFT and much of the code from FFTwaterfall to achieve a scrolling graph.

Each color represents a band on a logarithmic slice of the audio spectrum; for example the highest band is from 50% to the end of the FFT spectrum. the next highest band is from 25%-50%, and so on. This is by no means perfect, but it seems to work well enough.

Clicking adjusts the scale of the incoming sound based on the mouse X position: far left means small scale, far right means a larger scale. Faint lines are drawn onto the screen to give a sense of this scale.
