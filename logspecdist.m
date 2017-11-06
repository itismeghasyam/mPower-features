%% Log Spectral distance
% Assuming our signals have a length of 800, and are sampled at 100Hz

function lsd = logspecdist(x,y,nfft)
% N = max(length(x),length(y));
N = nfft;
xfft = fftshift(fft(x,N));
yfft = fftshift(fft(y,N));
xpsd = abs(xfft).^2;
ypsd = abs(yfft).^2;

lsd = sqrt((1/N)* sum( (10*(log10(xpsd)-log10(ypsd))).^2));

end