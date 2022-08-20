function [noisy,rec,recData,audPow,nPow] = noising(varargin)
%Recording an audio and add white guassian noise to it.
%   outputs:
% noisy:
%    audio that noises with white guassian noise
% rec:
%   main recorded audio
% recData:
%   data of main recorded audio
% audPow:
%   power of audio
% nPow:
%   power of noisy audio
%   
%   inputs:
% t:
%    length of recording.
% p:
%   For asking to plot from user
%Author: AliFathi 7/15/2021

%% Input recognition
flag = 0;
if(nargin == 0)
    t = 20;
elseif(nargin == 1)   
    if(strcmpi(varargin{1},'p')||strcmpi(varargin{1},'plot')||strcmpi(varargin{1},'plt'))
       flag =1;
       t = 20;
    elseif(isnumeric(varargin{1}))
    t = varargin{1};
    else
       error('Wrong input!');
    end
elseif(nargin == 2)
    t = varargin{1};
    if(strcmpi(varargin{2},'p')||strcmpi(varargin{2},'plot')||strcmpi(varargin{2},'plt'))
        flag = 1;
    else
        error('Wrong imput!');
    end

else
    error('Wrong input!');
end
%% Recording the audio
rec = audiorecorder(19e+3,8,1);
record(rec,t);
tic;
while toc<=(t+1)
    pause(1);
    disp('.');
end
%% Calculating the power
recData = getaudiodata(rec);
audPow = sum(abs(recData).^2)/length(recData);
pow = 10*log10(audPow);
noisy = awgn(recData,15,pow);
nPow = sum(abs(noisy).^2)/length(noisy);
%% Plot and saving
if(flag ==1)
    subplot(2,1,1);
    plot(recData(1:2000));
    title('Main audio');
    subplot(2,1,2);
    plot(noisy(1:2000),'r');
    title('Noisy audio');
end
save('nosyAudio','noisy');
save('mainRecord','rec');
try
    cd Audios;
catch
    mkdir('Audios');
    cd Audios;
end
audiowrite('mainRecord.wav',recData,19e+3);
audiowrite('noisyRecord.wav',noisy,19e+3);
cd ../;
end