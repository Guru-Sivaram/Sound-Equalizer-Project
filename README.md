# Sound-Equalizer-Project
Equalizer to manipulate .wav files in MATLAB

Description:
A user to import a .wav audio file and adjust the frequencies present within that audio file to their liking using the features presented in the GUI


Features:
Audio Player
This is where you import your sound file. Click import to select a file. 
It must be in .wav format already. Make sure your .m, .fig, and .wav files 
are all in the same folder before running the code.

Save:
Once you finish adjusting your audio to your liking, you may save your new audio 
using the save feature. It was saved into the same folder where you audio originated. 
Be sure to type '.wav' at the end of your new audio name.

Waveform Spectrum
Hit ‘Frequency’ to have the frequency plot of your audio signal appear either before
adjusting the frequencies and/or after. The difference between the before and after
frequency plots should be pretty noticeable, depending how much you adjusted each of
the frequencies. Hit ‘Time Plot’ to have the plot of your audio signal appear in the
time domain either before adjusting the frequencies and/or after.


Frequency Control Panel
This is the key part of the equalizer. 9 Sliders all representing low pass, band pass, a
nd high pass filters are there for optimal equalizing. Play with them! 
The more sliders available, the more accurately you can adjust the audio to your
liking. From left to right the values of frequencies within each slider increase in
order. When the file is first run, all of the frequencies will start at unity gain.
Slide up on each slider to increase the magnitude of that particular frequency range
positively. Slide down on each slider to increase the magnitude of that particular
frequency range negatively. A value of 0 will eliminate that particular range of
frequencies completely. Hit reset to have the sliders go back to their original
position.

Presets
This section is to be used if the user doesn’t have an extensive knowledge of
equalizing and doesn’t know which frequencies to adjust to get the sound they want.
Or, if the user just wants a quick adjustment to his or her audio and he or she is not
picky about the adjustment. However, the user must have a good idea pertaining to the
genre of the song. Then, the user can click on any of the preset options we have
available (Jazz, Pop, Rock, Reggae, Classical, and HipHop) to have a preloaded set of
frequency adjustments appear on the Frequency Control Panel which will give a general
enhancement to a song within that specific genre.

Required MATLAB toolboxes:
signal_toolbox

Tested On:
MATLAB version 2020a, 2020b on Windows 10
MATLAB online.



