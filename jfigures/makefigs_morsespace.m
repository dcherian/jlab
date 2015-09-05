function[]=makefigs_morsespace
%MAKEFIGS_MORSESPACE  Makes some sample figures for MORSESPACE.

%First figure
ga1=(1:.1:11);
be1=(1:.1:10);

[ga,be]=meshgrid(ga1,be1);

ompeak=morsefreq(ga,be);
ommax=morsehigh(ga,be,0.1,10);

figure
contourf(ga1,be1,(ompeak./ommax),20),colorbar,nocontours

title('Morse Wavelet  f_{peak} / f_{0.1} )
xlabel('Gamma Parameter')
ylabel('Beta Parameter')

%This is the ratio of the peak frequency to the ALPHA=0.1 frequency,
%that is, the frequency at which the wavelet has decayed to 0.1 of its
%peak value.  Large values of this ratio mean long high-frequency tails.

%Second figure
ga=3;
be=4;
alpha=0.1;
ompeak=morsefreq(ga,be);
N=100;

dom=ompeak/N+zeros(4*N,1);
om=cumsum(dom,1);

morse=frac(1,2)*morseafun(ga,be).*(om.^be).*exp(-om.^ga);
fhigh=morsehigh(ga,be,alpha);
figure,
plot(om,morse),xlabel('Radian frequency')
title('Morse wavelet high-frequency cutoff with \alpha=0.05')
vlines(fhigh),hlines(.1)


%Third figure
N=10001;
ga1=(1/3:.5:11);
be1=(1:.5:10);

L=50;

[ga,be]=meshgrid(ga1,be1);
vcolon(ga,be);
[a,sigt,sigo]=morsebox(ga,be);

psi=zeros(N,length(ga));

for i=1:length(ga)
    psi(:,i)=morsewave(N,ga(i),be(i),1/L,'energy');
end        

%Only use 1/2 of wavelet, but don't double-count the center point
psi=psi((end+1)/2:end,:);
psi=psi.*sqrt(2);
psi(1,:)=psi(1,:)./sqrt(2);
[p,skew,kurt]=morseprops(ga,be);
energy=cumsum(abs(psi).^2,1);
x=(1:size(energy,1))'./L;
x=oprod(x,1./p);

figure,plot(x,energy),axis([0 5 0 1.05])
ylabel('Fraction of total energy')
xlabel('Number of wavelet durations from center point')
vlines(sqrt(2)),hlines(0.95)

n=zeros(size(ga));
for i=1:length(ga)
    n(i)=find(energy(:,i)<0.95,1,'last');
end       
n=reshape(n,length(be1),length(ga1));
p=reshape(p,length(be1),length(ga1));

%Fourth figure
figure
plot(n./L,sqrt(2)*p)
xlabel('Number of periods to 95% energy')
ylabel('Wavelet duration x sqrt (2)')
dlines(1)

%These last two figures show that the wavelet duration P approximately
%controls the wavelet energy fraction integrated outward from the
%wavelet center. For example, integrating to a distance SQRT(2)*P
%captures roughly 95% of the energy for a broad parameter range.

