
%data processing for JRA3Q

clear
%date of each experiment
dates = [datenum('01-Dec-2013'):datenum('30-Nov-2020')];
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);
% plot a spatial pattern of climtology mean error of reanalyses in four season (DJF MAM JJA SON)
% so this is a pattern plot 6 (reanalysis+sate) x 4 (seasons)
x0=(1:length(datevec))';
[x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
[x2,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
[x3,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
[x4,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
X={x0,x1,x2,x3,x4};

for i=1:length(x0)
    
load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
JRA3Q_LWD_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWD_polargrid.nc','dlwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
JRA3Q_LWU_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWU_polargrid.nc','ulwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
JRA3Q_skt=nthroot((JRA3Q_LWU_per_day-(1-0.99).*JRA3Q_LWD_per_day)./(0.99.*5.67.*(10^(-8))),4);
JRA3Q_skt(JRA3Q_skt==0)=nan;
data_JRA3Q=permute(JRA3Q_skt,[2 1 3]);
data_ME_JRA3Q(:,:,i)=mean(data_JRA3Q-data_satellite,3,'omitnan'); 
end


j=1;
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME{j}=JRA3Q_ME_season;

load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')
figure
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,JRA3Q_ME{1});
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');

h=colorbar('eastoutside');
set(h,'fontsize',25,'tickdir','out','linewidth',1)
h.Label.String = '\circC';
set(h,'position',[.87 .20 .01 .57])


%with TCF cloud mask
for i=1:length(x0)
load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
JRA3Q_LWD_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWD_polargrid.nc','dlwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
JRA3Q_LWU_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWU_polargrid.nc','ulwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
JRA3Q_skt=nthroot((JRA3Q_LWU_per_day-(1-0.99).*JRA3Q_LWD_per_day)./(0.99.*5.67.*(10^(-8))),4);
JRA3Q_skt(JRA3Q_skt==0)=nan;
% add cloud mask here
   cloud_JRA3Q=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_TCC_polargrid.nc','tcdc-tcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
   JRA3Q_skt(cloud_JRA3Q>20)=nan;
data_JRA3Q=permute(JRA3Q_skt,[2 1 3]);
data_ME_JRA3Q(:,:,i)=mean(data_JRA3Q-data_satellite,3,'omitnan'); 
i
end







