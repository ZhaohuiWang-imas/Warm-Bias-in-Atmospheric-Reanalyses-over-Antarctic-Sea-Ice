%change to gauss resample in order to response to reviewer 3


clear
%date of each experiment
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);


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
save(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(date,:),'.mat'],'data_satellite')
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
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestr(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   data_ME_ERA5(:,:,i)=mean(data_ERA5-data_satellite,3,'omitnan'); 
   

   % MERRA2
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/MERRA2/MERRA2_regrid',datestr(x0(i),:),'.mat'])
   data_MERRA2=permute(data,[2 3 1]);
   data_MERRA2(data_MERRA2==0)=nan;
   data_ME_MERRA2(:,:,i)=mean(data_MERRA2-data_satellite,3,'omitnan'); 
   
   % NCEP2
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/NCEPR2/NCEPR2_regrid',datestr(x0(i),:),'.mat'])
   data_NCEPR2=permute(data,[2 3 1]);
   data_NCEPR2(data_NCEPR2==0)=nan;
   data_ME_NCEPR2(:,:,i)=mean(data_NCEPR2-data_satellite(:,:,1:6:end),3,'omitnan'); 
   
   % ERAI
   if i<=6118
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERAI/ERAI_regrid',datestr(x0(i),:),'.mat'])
   data_ERAI=permute(data,[2 3 1]);
   data_ERAI(data_ERAI==0)=nan;
   data_ME_ERAI(:,:,i)=mean(data_ERAI-data_satellite(:,:,1:6:end),3,'omitnan'); 
   end

   % JRA55
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestr(x0(i),:),'.mat'])
   data_JRA55=permute(JRA55_skt,[3 4 2 1]);
   data_JRA55=reshape(data_JRA55,[332,316,8]);
   data_JRA55(data_JRA55==0)=nan;
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   data_ME_JRA55(:,:,i)=mean(data_JRA55-data_satellite_JRA55,3,'omitnan'); 
   
end

cd /Volumes/ExtremePro/MODIS_gauss
save data_ME_gauss17km.mat data_ME* -v7.3

%% with TCF cloud mask

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
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestr(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   % add cloud mask here
   cloud_ERA5=ncread('/Volumes/ExtremePro/WANG_SSD/ERA5_cloud/ERA5_cloudcover_all_polargrid.nc','var164',[1 1 8017+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   data_ERA5(cloud_ERA5>0.2)=nan;
   data_ME_ERA5(:,:,i)=mean(data_ERA5-data_satellite,3,'omitnan'); 
   
   % MERRA2
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/MERRA2/MERRA2_regrid',datestr(x0(i),:),'.mat'])
   data_MERRA2=permute(data,[2 3 1]);
   data_MERRA2(data_MERRA2==0)=nan;
   % add cloud mask here
   cloud_MERRA2=ncread('/Volumes/ExtremePro/WANG_SSD/MERRA2_cloud/MERRA2_cloudcover_all_polargrid.nc','CLDTOT',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_MERRA2=permute(cloud_MERRA2,[2 1 3]);
   data_MERRA2(cloud_MERRA2>0.2)=nan;
   data_ME_MERRA2(:,:,i)=mean(data_MERRA2-data_satellite,3,'omitnan'); 
   
   % NCEP2
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/NCEPR2/NCEPR2_regrid',datestr(x0(i),:),'.mat'])
   data_NCEPR2=permute(data,[2 3 1]);
   data_NCEPR2(data_NCEPR2==0)=nan;
   % add cloud mask here
   cloud_NCEPR2=ncread('/Volumes/ExtremePro/WANG_SSD/NCEPR2_cloud/NCEPR2_cloud_merge_polargrid.nc','tcdc',[1 1 1337+4*(i-1)],[Inf Inf 4]);
   cloud_NCEPR2=permute(cloud_NCEPR2,[2 1 3]);
   data_NCEPR2(cloud_NCEPR2>20)=nan;
   data_ME_NCEPR2(:,:,i)=mean(data_NCEPR2-data_satellite(:,:,1:6:end),3,'omitnan'); 
   
   % ERAI
   if i<=6118
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERAI/ERAI_regrid',datestr(x0(i),:),'.mat'])
   data_ERAI=permute(data,[2 3 1]);
   data_ERAI(data_ERAI==0)=nan;
   % add cloud mask here
   cloud_ERAI=ncread('/Volumes/ExtremePro/WANG_SSD/ERAI_cloud/ERAI_cloudcover_all_polargrid.nc','tcc',[1 1 1337+4*(i-1)],[Inf Inf 4]);
   cloud_ERAI=permute(cloud_ERAI,[2 1 3]);
   data_ERAI(cloud_ERAI>0.2)=nan;
   data_ME_ERAI(:,:,i)=mean(data_ERAI-data_satellite(:,:,1:6:end),3,'omitnan'); 
   end

   % JRA55
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestr(x0(i),:),'.mat'])
   data_JRA55=permute(JRA55_skt,[3 4 2 1]);
   data_JRA55=reshape(data_JRA55,[332,316,8]);
   data_JRA55(data_JRA55==0)=nan;
   % add cloud mask here
   cloud_JRA55=ncread('/Volumes/ExtremePro/WANG_SSD/JRA55_cloud/JRA55_cloud_merge_polargrid.nc','TCDC_GDS4_ISBY',[1 1 2673+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   data_JRA55(cloud_JRA55>20)=nan;
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   data_ME_JRA55(:,:,i)=mean(data_JRA55-data_satellite_JRA55,3,'omitnan'); 
   
end

cd /Volumes/ExtremePro/MODIS_gauss
save data_ME_02cloud_gauss17km.mat data_ME* -v7.3
