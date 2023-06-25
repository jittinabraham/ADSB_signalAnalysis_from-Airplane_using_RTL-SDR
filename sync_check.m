clear all
close all
%reshape(remat(s,6,1),1,[])
preamble=[1 0 1 0 0 0 0 1 0 1 0 0 0 0 0 0];
err=1;
 load('rx-2023-3-31-17-5-47.mat'); 
interpolator=dsp.FIRInterpolator(5);

y=interpolator(y1);
Interpolated_preamble=repmat(preamble,6,1);

Interpolated_preamble=reshape(Interpolated_preamble,1,[]);
y1=conj(y);

realSignal=y.*y1;
clear y1;
s_len=length(Interpolated_preamble);
corr=zeros(length(Interpolated_preamble)-s_len);
%matric calculation coorrelation
for j=1:length(realSignal)-length(Interpolated_preamble)
    slidingwindow=realSignal(j:j+s_len-1);
    corr(j)=sum(Interpolated_preamble.*slidingwindow');
    dist(j)=sqrt(sum((slidingwindow'-Interpolated_preamble).^2));
    
end
[~,peakIndx]=maxk(corr,5000);
 j=1;

clear slidingwindow;
while(err==1)
   

        indxD=peakIndx(j)
        sync1=realSignal(indxD:indxD+s_len-1);
       
        
    x=realSignal(indxD+s_len:end);
    pad_size=mod(numel(x),12);
    pad_size=12-pad_size;
    x_padded=[x;zeros(pad_size,1)];
    X_matrix=reshape(x_padded,12,[]);
    X_matrix=X_matrix(:,1:112);
    packet1 = sum( X_matrix(1:6,:) ) > sum( X_matrix(7:12,:) );   
    crcADSB = comm.CRCDetector(logical([1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]));
    
    [~,err]=crcADSB(packet1')
    j=j+1;
         
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 