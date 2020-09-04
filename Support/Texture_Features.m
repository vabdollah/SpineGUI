function [out]=Texture_Features(glcmin,pairs)
%{
  This function has been written for DICOM texture analysis program by Vahid Abdollah PhD,
  Vahid Abdollah PhD Postdoctoral Associate, 
  Department of Radiology, Cumming School of Medicine
  University of Calgary, Calgary, AB, CA T2N 4N1
  This software is issued without express warranty, no express guarantee of fidelity, 
  and the author is not responsible for the intended or unintended results of usage of this software. 
  Quality verification of data obtained using the Knee_Aanlyser and results drawn from 
  that data are the sole responsibility of the end user.
  All Rights Reserved. This software is intended for use in whole, and shall not be altered, 
  used in part, or modified WITHOUT THE PRIOR WRITTEN CONSENT OF THE AUTHOR.
  References:
  1. R. M. Haralick, K. Shanmugam, and I. Dinstein, Textural Features of
  Image Classification, IEEE Transactions on Systems, Man and Cybernetics,
  vol. SMC-3, no. 6, Nov. 1973
  2. L. Soh and C. Tsatsoulis, Texture Analysis of SAR Sea Ice Imagery
  Using Gray Level Co-Occurrence Matrices, IEEE Transactions on Geoscience
  and Remote Sensing, vol. 37, no. 2, March 1999.
  3. D A. Clausi, An analysis of co-occurrence texture statistics as a
  function of grey level quantization, Can. J. Remote Sensing, vol. 28, no.
  1, pp. 45-62, 2002
  4. http://murphylab.web.cmu.edu/publications/boland/boland_node26.html
%}
if ((nargin>2)||(nargin==0))
   error('Too many or too few input arguments. Enter GLCM and pairs.');
elseif ((nargin==2)) 
    if ((size(glcmin,1)<=1)||(size(glcmin,2)<=1))
       error('The GLCM should be a 2-D or 3-D matrix.');
    elseif (size(glcmin,1)~=size(glcmin,2))
        error('Each GLCM should be square with NumLevels rows and NumLevels cols');
    end    
elseif (nargin==1) % only GLCM is entered
    pairs=0; % default is numbers and input 1 for percentage
    if ((size(glcmin,1)<=1)||(size(glcmin,2)<=1))
       error('The GLCM should be a 2-D or 3-D matrix.');
    elseif (size(glcmin,1)~=size(glcmin,2))
       error('Each GLCM should be square with NumLevels rows and NumLevels cols');
    end    
end
format long e
if (pairs==1)
    newn=1;
    for nglcm=1:2:size(glcmin,3)
        glcm(:,:,newn) =glcmin(:,:,nglcm)+glcmin(:,:,nglcm+1);
        newn=newn+1;
    end
elseif (pairs==0)
    glcm=glcmin;
end
size_glcm_1=size(glcm,1);
size_glcm_2=size(glcm,2);
size_glcm_3=size(glcm,3);
% checked 
out.autoc=zeros(1,size_glcm_3); % Autocorrelation: [2] 
out.contr=zeros(1,size_glcm_3); % Contrast: matlab/[1,2]
out.corrm=zeros(1,size_glcm_3); % Correlation: matlab
out.corrp=zeros(1,size_glcm_3); % Correlation: [1,2]
out.cprom=zeros(1,size_glcm_3); % Cluster Prominence: [2]
out.cshad=zeros(1,size_glcm_3); % Cluster Shade: [2]
out.dissi=zeros(1,size_glcm_3); % Dissimilarity: [2]
out.energ=zeros(1,size_glcm_3); % Energy: matlab / [1,2]
out.entro=zeros(1,size_glcm_3); % Entropy: [2]
out.homom=zeros(1,size_glcm_3); % Homogeneity: matlab
out.homop=zeros(1,size_glcm_3); % Homogeneity: [2]
out.maxpr=zeros(1,size_glcm_3); % Maximum probability: [2]
out.sosvh=zeros(1,size_glcm_3); % Sum of sqaures: Variance [1]
out.savgh=zeros(1,size_glcm_3); % Sum average [1]
out.svarh=zeros(1,size_glcm_3); % Sum variance [1]
out.senth=zeros(1,size_glcm_3); % Sum entropy [1]
out.dvarh=zeros(1,size_glcm_3); % Difference variance [4]
out.denth=zeros(1,size_glcm_3); % Difference entropy [1]
out.inf1h=zeros(1,size_glcm_3); % Information measure of correlation1 [1]
out.inf2h=zeros(1,size_glcm_3); % Informaiton measure of correlation2 [1]
out.indnc=zeros(1,size_glcm_3); % Inverse difference normalized (INN) [3]
out.idmnc=zeros(1,size_glcm_3); % Inverse difference moment normalized [3]
glcm_sum =zeros(size_glcm_3,1);
glcm_mean=zeros(size_glcm_3,1);
glcm_var =zeros(size_glcm_3,1);
u_x=zeros(size_glcm_3,1);
u_y=zeros(size_glcm_3,1);
s_x=zeros(size_glcm_3,1);
s_y=zeros(size_glcm_3,1);
% checked p_x p_y p_xplusy p_xminusy
p_x=zeros(size_glcm_1,size_glcm_3); % Ng x #glcms[1]  
p_y=zeros(size_glcm_2,size_glcm_3); % Ng x #glcms[1]
p_xplusy=zeros((size_glcm_1*2-1),size_glcm_3); %[1]
p_xminusy=zeros((size_glcm_1),size_glcm_3); %[1]
% checked hxy hxy1 hxy2 hx hy
hxy =zeros(size_glcm_3,1);
hxy1=zeros(size_glcm_3,1);
hx=zeros(size_glcm_3,1);
hy=zeros(size_glcm_3,1);
hxy2=zeros(size_glcm_3,1);
for k=1:size_glcm_3 % number glcms
    glcm_sum(k)=sum(sum(glcm(:,:,k)));
    glcm(:,:,k)=glcm(:,:,k)./glcm_sum(k); % Normalize each glcm
    glcm_mean(k)=mean2(glcm(:,:,k)); % compute mean after norm
    glcm_var(k) =(std2(glcm(:,:,k)))^2;    
    for i=1:size_glcm_1
        for j=1:size_glcm_2
            out.contr(k)=out.contr(k)+(abs(i-j))^2.*glcm(i,j,k);
            out.dissi(k)=out.dissi(k)+(abs(i-j)*glcm(i,j,k));
            out.energ(k)=out.energ(k)+(glcm(i,j,k).^2);
            out.entro(k)=out.entro(k)-(glcm(i,j,k)*log(glcm(i,j,k)+eps));
            out.homom(k)=out.homom(k)+(glcm(i,j,k)/( 1+abs(i-j) ));
            out.homop(k)=out.homop(k)+(glcm(i,j,k)/( 1+(i-j)^2));
            out.sosvh(k)=out.sosvh(k)+glcm(i,j,k)*((i-glcm_mean(k))^2);
            out.indnc(k)=out.indnc(k)+(glcm(i,j,k)/( 1+(abs(i-j)/size_glcm_1) ));
            out.idmnc(k)=out.idmnc(k)+(glcm(i,j,k)/( 1+((i-j)/size_glcm_1)^2));
            u_x(k)=u_x(k)+(i)*glcm(i,j,k); % changed 10/26/08
            u_y(k)=u_y(k)+(j)*glcm(i,j,k); % changed 10/26/08
        end        
    end
    out.maxpr(k)=max(max(glcm(:,:,k)));
end
for k=1:size_glcm_3    
    for i=1:size_glcm_1        
        for j=1:size_glcm_2
            p_x(i,k)=p_x(i,k)+glcm(i,j,k); 
            p_y(i,k)=p_y(i,k)+glcm(j,i,k); % taking i for j and j for i
            if (ismember((i+j),2:2*size_glcm_1)) 
                p_xplusy((i+j)-1,k)=p_xplusy((i+j)-1,k)+glcm(i,j,k);
            end
            if (ismember(abs(i-j),0:(size_glcm_1-1))) 
                p_xminusy((abs(i-j))+1,k)=p_xminusy((abs(i-j))+1,k)+glcm(i,j,k);
            end
        end
    end    
end
for k=1:(size_glcm_3)    
    for i=1:(2*(size_glcm_1)-1)
        out.savgh(k)=out.savgh(k)+(i+1)*p_xplusy(i,k);
        out.senth(k)=out.senth(k)-(p_xplusy(i,k)*log(p_xplusy(i,k)+eps));
    end
end
for k=1:(size_glcm_3)    
    for i=1:(2*(size_glcm_1)-1)
        out.svarh(k)=out.svarh(k)+(((i+1)-out.senth(k))^2)*p_xplusy(i,k);
    end
end
% compute difference variance, difference entropy, 
for k=1:size_glcm_3
    for i=0:(size_glcm_1-1)
        out.denth(k)=out.denth(k)-(p_xminusy(i+1,k)*log(p_xminusy(i+1,k)+eps));
        out.dvarh(k)=out.dvarh(k)+(i^2)*p_xminusy(i+1,k);
    end
end
% compute information measure of correlation(1,2) [1]
for k=1:size_glcm_3
    hxy(k)=out.entro(k);
    for i=1:size_glcm_1        
        for j=1:size_glcm_2
            hxy1(k)=hxy1(k)-(glcm(i,j,k)*log(p_x(i,k)*p_y(j,k)+eps));
            hxy2(k)=hxy2(k)-(p_x(i,k)*p_y(j,k)*log(p_x(i,k)*p_y(j,k)+eps));
        end
        hx(k)=hx(k)-(p_x(i,k)*log(p_x(i,k)+eps));
        hy(k)=hy(k)-(p_y(i,k)*log(p_y(i,k)+eps));
    end
    out.inf1h(k)=( hxy(k)-hxy1(k) )/( max([hx(k),hy(k)]) );
    out.inf2h(k)=(1-exp(-2*(hxy2(k)-hxy(k))))^0.5;
end
corm=zeros(size_glcm_3,1);
corp=zeros(size_glcm_3,1);
for k=1:size_glcm_3
    for i=1:size_glcm_1
        for j=1:size_glcm_2
            s_x(k)=s_x(k)+(((i)-u_x(k))^2)*glcm(i,j,k);
            s_y(k)=s_y(k)+(((j)-u_y(k))^2)*glcm(i,j,k);
            corp(k)=corp(k)+((i)*(j)*glcm(i,j,k));
            corm(k)=corm(k)+(((i)-u_x(k))*((j)-u_y(k))*glcm(i,j,k));
            out.cprom(k)=out.cprom(k)+(((i+j-u_x(k)-u_y(k))^4)*glcm(i,j,k));
            out.cshad(k)=out.cshad(k)+(((i+j-u_x(k)-u_y(k))^3)*glcm(i,j,k));
        end
    end
    s_x(k)=s_x(k)^0.5;
    s_y(k)=s_y(k)^0.5;
    out.autoc(k)=corp(k);
    out.corrp(k)=(corp(k)-u_x(k)*u_y(k))/(s_x(k)*s_y(k));
    out.corrm(k)=corm(k)/(s_x(k)*s_y(k));
end
