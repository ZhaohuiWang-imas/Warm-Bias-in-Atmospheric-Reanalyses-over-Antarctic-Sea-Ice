%% inter-annual varibility
clear
%date of each experiment
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);


% pick up data point at 80%
% useful IST of MODIS aqua and Terra
for date =1:6575
if datevec(date,1)<=2007
seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(date,:),'_f13_v04r00.nc'],'cdr_seaice_conc');
else
seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(date,:),'_f17_v04r00.nc'],'cdr_seaice_conc');
end
seaice_cdr=seaice';
seaice_cdr(seaice_cdr>1)=0;
%%MODIS Aqua
eval(['load /Volumes/ExtremePro/MODIS_gauss/MYD29_L2_hourly_clearsky_gauss17km/MYD29_',datestr(date,:)])
for i=1:24
data_hour=data_that_hours(:,:,i);
data_hour(seaice_cdr<0.8)=0;
data_hour(isnan(seaice_cdr))=0;
data_aqua(:,:,i)=data_hour;
end
%%MODIS Terra
eval(['load /Volumes/ExtremePro/MODIS_gauss/MOD29_L2_hourly_clearsky_gauss17km/MOD29_',datestr(date,:)])
for i=1:24
data_hour=data_that_hours(:,:,i);
data_hour(seaice_cdr<0.8)=0;
data_hour(isnan(seaice_cdr))=0;
data_terra(:,:,i)=data_hour;
end
data_aqua(data_aqua==0)=nan;
data_terra(data_terra==0)=nan;
data_both=cat(4,data_aqua,data_terra);
data_satellite=nanmean(data_both,4);
save(['/Volumes/ExtremePro/IST_SIC_80_100_2024/IST_Satellite_80SIC/IST_satellite_',datestr(date,:),'.mat'],'data_satellite')
end

% pick up data point at 100%
for date =1:6575
if datevec(date,1)<=2007
seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(date,:),'_f13_v04r00.nc'],'cdr_seaice_conc');
else
seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(date,:),'_f17_v04r00.nc'],'cdr_seaice_conc');
end
seaice_cdr=seaice';
seaice_cdr(seaice_cdr>1)=0;
%%MODIS Aqua
eval(['load /Volumes/ExtremePro/MODIS_gauss/MYD29_L2_hourly_clearsky_gauss17km/MYD29_',datestr(date,:)])
for i=1:24
data_hour=data_that_hours(:,:,i);
data_hour(seaice_cdr<0.99)=0;
data_hour(isnan(seaice_cdr))=0;
data_aqua(:,:,i)=data_hour;
end
%%MODIS Terra
eval(['load /Volumes/ExtremePro/MODIS_gauss/MOD29_L2_hourly_clearsky_gauss17km/MOD29_',datestr(date,:)])
for i=1:24
data_hour=data_that_hours(:,:,i);
data_hour(seaice_cdr<0.99)=0;
data_hour(isnan(seaice_cdr))=0;
data_terra(:,:,i)=data_hour;
end
data_aqua(data_aqua==0)=nan;
data_terra(data_terra==0)=nan;
data_both=cat(4,data_aqua,data_terra);
data_satellite=nanmean(data_both,4);
save(['/Volumes/ExtremePro/IST_SIC_80_100_2024/IST_Satellite_100SIC/IST_satellite_',datestr(date,:),'.mat'],'data_satellite')
end


clear
%date of each experiment
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
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
   load(['/Volumes/ExtremePro/IST_SIC_80_100_2024/IST_Satellite_100SIC/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestr(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   data_ME_ERA5(:,:,i)=nanmean(data_ERA5-data_satellite,3); 
   
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/MERRA2/MERRA2_regrid',datestr(x0(i),:),'.mat'])
   data_MERRA2=permute(data,[2 3 1]);
   data_MERRA2(data_MERRA2==0)=nan;
   data_ME_MERRA2(:,:,i)=nanmean(data_MERRA2-data_satellite,3); 
   
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/NCEPR2/NCEPR2_regrid',datestr(x0(i),:),'.mat'])
   data_NCEPR2=permute(data,[2 3 1]);
   data_NCEPR2(data_NCEPR2==0)=nan;
   data_ME_NCEPR2(:,:,i)=nanmean(data_NCEPR2-data_satellite(:,:,1:6:end),3); 
   
   if x0(i)<=6118
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERAI/ERAI_regrid',datestr(x0(i),:),'.mat'])
   data_ERAI=permute(data,[2 3 1]);
   data_ERAI(data_ERAI==0)=nan;
   data_ME_ERAI(:,:,i)=nanmean(data_ERAI-data_satellite(:,:,1:6:end),3); 
   end
   
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestr(x0(i),:),'.mat'])
   data_JRA55=permute(JRA55_skt,[3 4 2 1]);
   data_JRA55=reshape(data_JRA55,[332,316,8]);
   data_JRA55(data_JRA55==0)=nan;
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=nanmean(data_satellite(:,:,fr*3-2:fr*3),3);
   end
   data_ME_JRA55(:,:,i)=nanmean(data_JRA55-data_satellite_JRA55,3); 
   
end

for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME_100{j}=ERA5_ME_season;

MERRA2_ME_season=nanmean(data_ME_MERRA2(:,:,X{j}),3);
MERRA2_ME_100{j}=MERRA2_ME_season;

NCEPR2_ME_season=nanmean(data_ME_NCEPR2(:,:,X{j}),3);
NCEPR2_ME_100{j}=NCEPR2_ME_season;

ERAI_ME_season=nanmean(data_ME_ERAI(:,:,X{j}(X{j}<=6118)),3);
ERAI_ME_100{j}=ERAI_ME_season;

JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME_100{j}=JRA55_ME_season;
end

cd /Volumes/ExtremePro/MODIS_gauss
load('data_ME_gauss17km.mat')

for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME{j}=ERA5_ME_season;

MERRA2_ME_season=nanmean(data_ME_MERRA2(:,:,X{j}),3);
MERRA2_ME{j}=MERRA2_ME_season;

NCEPR2_ME_season=nanmean(data_ME_NCEPR2(:,:,X{j}),3);
NCEPR2_ME{j}=NCEPR2_ME_season;

ERAI_ME_season=nanmean(data_ME_ERAI(:,:,X{j}(X{j}<=6118)),3);
ERAI_ME{j}=ERAI_ME_season;

JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME{j}=JRA55_ME_season;

end


figure
%set(gcf,'unit','normalized','position',[.1 .1 .6 .85])
data_name={'ERA5', 'ERAI', 'MERRA2', 'NCEPR2', 'JRA55','FNL'};
season={'100% SIC','80% SIC','AMJ','JAS','OND'};

for i=1:5
    for j=1
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME_100{j}']));
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if j==1
title(data_name{i},'FontSize',16)
end
if i==1
ylabel(season{j},'FontSize',16,'FontWeight','bold')
end

    end
%m_text(-45,-45,text_no1{i},'fontsize',25,'fontname','bold')
end

for i=1:5
    for j=2
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(2-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j-1}']));
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if j==1
title(data_name{i},'FontSize',16)
end
if i==1
ylabel(season{j},'FontSize',16,'FontWeight','bold')
end

    end
%m_text(-45,-45,text_no2{i},'fontsize',25,'fontname','bold')
end


