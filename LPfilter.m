function [filter,dSignal] = LPfilter(varargin)
%Generate a lowpass FIR filter 
%Compare a noisy audio with filtered audio
%Author: AliFathi 7/15/2021
%% Input recognition
flag1 =0;
flag2 = 0;
fp = 5e3;
if(nargin == 0)
elseif(nargin == 1)  
    if isvector(varargin{1})  %#ok
        noisySignal = varargin{1};
        flag2 = 1;
    elseif ~isvector(varargin{1}) && ~isstring(varargin{1}) % user defined pass frequency
        fp = varargin{1};
    else
        error('Wrong input!');
end
elseif(nargin == 2)
    if isvector(varargin{1})
        noisySignal = varargin{1};
        flag2 = 1;
    else ~isvector(varargin{1})     %#ok
        error('Wrong input!');
    end
    if strcmpi(varargin{2},'compare') || strcmpi(varargin{2},'c') || strcmpi(varargin{2},'cmp')
        flag1 =1;
    elseif ~isstring(varargin{2})   % user defined pass frequency
        fp = varargin{2};
    else
        error('Wrong input!');
    end
elseif(nargin == 3)
    if isvector(varargin{1})
        noisySignal = varargin{1};
        flag2 =1;
    else ~isvector(varargin{1})     %#ok
        error('Wrong input!');
    end
    if isnumeric(varargin{2})
       fp = varargin{2}; 
    else(isstring(varargin{2}))  %#ok
        error('Wrong input!');
    end
    if strcmpi(varargin{3},'compare') || strcmpi(varargin{3},'c') || strcmpi(varargin{3},'cmp')
        flag1 = 1;
    else
        error('Wrong input!');
    end

end
%% Design the filter
n   = 100;
fs  = 19e3;             
ap  = 0.01;      
ast = 100;
rp  = (10^(ap/20) - 1)/(10^(ap/20) + 1);
rst = 10^(-ast/20);
filter = firceqrip(n,fp/(fs/2),[rp rst]);
%% Denoising
if flag2 ==1
    dSignal = conv(noisySignal,filter);
    try
        cd Audios;
    catch
        mkdir('Audios');
        cd Audios;
    end
    audiowrite('FilteredAud.wav',dSignal,19e+3);
    cd ../;
end
%% Comparing 
if(flag1 == 1)
    disp('Noisy signal');
    z = audioplayer(dSignal,19e3);
    y = audioplayer(noisySignal,19e3);
    y.play;
    figure(1);
    plot(noisySignal(1:2000));
    title('Noisy Signal');
    grid on;
    nspower = sum(abs(noisySignal).^2)/length(noisySignal);
    disp("signals power = " + num2str(nspower));
    disp("variance = "+num2str(var(noisySignal)));
    while(y.isplaying)
        pause(1);
        disp('.');
    end
    close;
    disp('DenoisedSignal');
    z.play;
    figure(2);
    subplot(2,1,1);
    plot(noisySignal(1:2000));
    title('Noisy Signal');
    grid on;
    subplot(2,1,2);
    plot(dSignal(1:2000),'r');
    title('Denoised Signal');
    grid on;
    dspower = sum(abs(dSignal).^2)/length(dSignal);
    disp("signals power = "+num2str(dspower));
    disp("variance = "+num2str(var(dSignal)));
    while(z.isplaying)
        pause(1);
        disp('.');
    end
    close;
end
end