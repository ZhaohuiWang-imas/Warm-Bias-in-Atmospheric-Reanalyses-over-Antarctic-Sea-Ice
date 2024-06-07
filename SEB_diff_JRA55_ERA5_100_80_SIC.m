%% examing the SEB between 80% and 100% SIC area


%% SEB condition when only considering 100% SIC

clear
%date of each experiment
dates = datenum('01-Dec-2002'):datenum('30-Nov-2020');
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);

x0=(1:length(datevec))';
[x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
[x2,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
[x3,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
[x4,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
X={x0,x1,x2,x3,x4};

time=1;
for i=1:length(x0)
   load(['/Volumes/ExtremePro/IST_SIC_80_100_2024/IST_Satellite_100SIC/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5 radiation 
   % downward shortwave 
   msdwswrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwswrf_all.nc','var35',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwswrf_ERA5=permute(msdwswrf_ERA5,[2 1 3]);
   msdwswrf_ERA5(isnan(data_satellite))=nan;
   data_msdwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5,3,'omitnan'); 
   % upward shortwave 
   msnswrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnswrf_all.nc','var37',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnswrf_ERA5=permute(msnswrf_ERA5,[2 1 3]);
   msnswrf_ERA5(isnan(data_satellite))=nan;
   data_msuwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5-msnswrf_ERA5,3,'omitnan'); 
   % downward longwave 
   msdwlwrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwlwrf_all.nc','var36',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwlwrf_ERA5=permute(msdwlwrf_ERA5,[2 1 3]);
   msdwlwrf_ERA5(isnan(data_satellite))=nan;
   data_msdwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5,3,'omitnan'); 
   % upward longwave 
   msnlwrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnlwrf_all.nc','var38',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnlwrf_ERA5=permute(msnlwrf_ERA5,[2 1 3]);
   msnlwrf_ERA5(isnan(data_satellite))=nan;
   data_msuwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5-msnlwrf_ERA5,3,'omitnan'); 
   % sensible heat flux
   msshf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msshf_all.nc','var33',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msshf_ERA5=permute(msshf_ERA5,[2 1 3]);
   msshf_ERA5(isnan(data_satellite))=nan;
   data_msshf_ERA5(:,:,i)=mean(-msshf_ERA5,3,'omitnan'); 
   % latent heat flux
   mslhf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_mslhf_all.nc','var34',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   mslhf_ERA5=permute(mslhf_ERA5,[2 1 3]);
   mslhf_ERA5(isnan(data_satellite))=nan;
   data_mslhf_ERA5(:,:,i)=mean(-mslhf_ERA5,3,'omitnan'); 

   % JRA55 radiation   
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end   
   % downward shortwave
   dswrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dswrf_all_polargrid.nc','DSWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dswrf_JRA55=permute(dswrf_JRA55,[2 1 3 4]);
   dswrf_JRA55=reshape(dswrf_JRA55,[332 316 8]);
   dswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   data_dswrf_JRA55(:,:,i)=mean(dswrf_JRA55,3,'omitnan');
   % upward shortwave
   uswrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_uswrf_all_polargrid.nc','USWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   uswrf_JRA55=permute(uswrf_JRA55,[2 1 3 4]);
   uswrf_JRA55=reshape(uswrf_JRA55,[332 316 8]);
   uswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   data_uswrf_JRA55(:,:,i)=mean(uswrf_JRA55,3,'omitnan');
   % downward longwave 
   dlwrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dlwrf_all_polargrid.nc','DLWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dlwrf_JRA55=permute(dlwrf_JRA55,[2 1 3 4]);
   dlwrf_JRA55=reshape(dlwrf_JRA55,[332 316 8]);
   dlwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   data_dlwrf_JRA55(:,:,i)=mean(dlwrf_JRA55,3,'omitnan');
   % upward longwave
   ulwrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_ulwrf_all_polargrid.nc','ULWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   ulwrf_JRA55=permute(ulwrf_JRA55,[2 1 3 4]);
   ulwrf_JRA55=reshape(ulwrf_JRA55,[332 316 8]);
   ulwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   data_ulwrf_JRA55(:,:,i)=mean(ulwrf_JRA55,3,'omitnan');
   % sensible heat flux
   shtfl_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_shtfl_all_polargrid.nc','SHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   shtfl_JRA55=permute(shtfl_JRA55,[2 1 3 4]);
   shtfl_JRA55=reshape(shtfl_JRA55,[332 316 8]);
   shtfl_JRA55(isnan(data_satellite_JRA55))=nan;
   data_shtfl_JRA55(:,:,i)=mean(shtfl_JRA55,3,'omitnan');
   % latent heat flux
   lhtfl_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_lhtfl_all_polargrid.nc','LHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   lhtfl_JRA55=permute(lhtfl_JRA55,[2 1 3 4]);
   lhtfl_JRA55=reshape(lhtfl_JRA55,[332 316 8]);
   lhtfl_JRA55(isnan(data_satellite_JRA55))=nan;
   data_lhtfl_JRA55(:,:,i)=mean(lhtfl_JRA55,3,'omitnan');


   time=time+1
end


%%


for j=1:5
ERA5_dswrf_season{j}=mean(data_msdwswrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_uswrf_season{j}=mean(data_msuwswrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_dlwrf_season{j}=mean(data_msdwlwrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_ulwrf_season{j}=mean(data_msuwlwrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_shf_season{j}=mean(data_msshf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_lhf_season{j}=mean(data_mslhf_ERA5(:,:,X{j}),3,'omitnan');


JRA55_dswrf_season{j}=mean(data_dswrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_uswrf_season{j}=mean(data_uswrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_dlwrf_season{j}=mean(data_dlwrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_ulwrf_season{j}=mean(data_ulwrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_shf_season{j}=mean(data_shtfl_JRA55(:,:,X{j}),3,'omitnan');
JRA55_lhf_season{j}=mean(data_lhtfl_JRA55(:,:,X{j}),3,'omitnan');
end

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
save ERA5_radiation_100SIC ERA5* data*ERA5 -v7.3
save JRA55_radiation_100SIC JRA55* data*JRA55 -v7.3





%% clear sky

time=1;
for i=1:length(x0)
   load(['/Volumes/ExtremePro/IST_SIC_80_100_2024/IST_Satellite_100SIC/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % add cloud mask here
   cloud_ERA5=ncread('/Volumes/ExtremePro/WANG_SSD/ERA5_cloud/ERA5_cloudcover_all_polargrid.nc','var164',[1 1 8017+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
 
   % ERA5 radiation 
   % downward shortwave 
   msdwswrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwswrf_all.nc','var35',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwswrf_ERA5=permute(msdwswrf_ERA5,[2 1 3]);
   msdwswrf_ERA5(isnan(data_satellite))=nan;
   msdwswrf_ERA5(cloud_ERA5>0.2)=nan;
   data_msdwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5,3,'omitnan'); 
   % upward shortwave 
   msnswrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnswrf_all.nc','var37',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnswrf_ERA5=permute(msnswrf_ERA5,[2 1 3]);
   msnswrf_ERA5(isnan(data_satellite))=nan;
   msnswrf_ERA5(cloud_ERA5>0.2)=nan;
   data_msuwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5-msnswrf_ERA5,3,'omitnan'); 
   % downward longwave 
   msdwlwrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwlwrf_all.nc','var36',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwlwrf_ERA5=permute(msdwlwrf_ERA5,[2 1 3]);
   msdwlwrf_ERA5(isnan(data_satellite))=nan;
   msdwlwrf_ERA5(cloud_ERA5>0.2)=nan;
   data_msdwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5,3,'omitnan'); 
   % upward longwave 
   msnlwrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnlwrf_all.nc','var38',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnlwrf_ERA5=permute(msnlwrf_ERA5,[2 1 3]);
   msnlwrf_ERA5(isnan(data_satellite))=nan;
   msnlwrf_ERA5(cloud_ERA5>0.2)=nan;
   data_msuwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5-msnlwrf_ERA5,3,'omitnan'); 
   % sensible heat flux
   msshf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msshf_all.nc','var33',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msshf_ERA5=permute(msshf_ERA5,[2 1 3]);
   msshf_ERA5(isnan(data_satellite))=nan;
   msshf_ERA5(cloud_ERA5>0.2)=nan;
   data_msshf_ERA5(:,:,i)=mean(-msshf_ERA5,3,'omitnan'); 
   % latent heat flux
   mslhf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_mslhf_all.nc','var34',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   mslhf_ERA5=permute(mslhf_ERA5,[2 1 3]);
   mslhf_ERA5(isnan(data_satellite))=nan;
   mslhf_ERA5(cloud_ERA5>0.2)=nan;
   data_mslhf_ERA5(:,:,i)=mean(-mslhf_ERA5,3,'omitnan'); 

   % JRA55 radiation   
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end   
   % add cloud mask here
   cloud_JRA55=ncread('/Volumes/ExtremePro/WANG_SSD/JRA55_cloud/JRA55_cloud_merge_polargrid.nc','TCDC_GDS4_ISBY',[1 1 2673+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);

   % downward shortwave
   dswrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dswrf_all_polargrid.nc','DSWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dswrf_JRA55=permute(dswrf_JRA55,[2 1 3 4]);
   dswrf_JRA55=reshape(dswrf_JRA55,[332 316 8]);
   dswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   dswrf_JRA55(cloud_JRA55>20)=nan;
   data_dswrf_JRA55(:,:,i)=mean(dswrf_JRA55,3,'omitnan');
   % upward shortwave
   uswrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_uswrf_all_polargrid.nc','USWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   uswrf_JRA55=permute(uswrf_JRA55,[2 1 3 4]);
   uswrf_JRA55=reshape(uswrf_JRA55,[332 316 8]);
   uswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   uswrf_JRA55(cloud_JRA55>20)=nan;
   data_uswrf_JRA55(:,:,i)=mean(uswrf_JRA55,3,'omitnan');
   % downward longwave 
   dlwrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dlwrf_all_polargrid.nc','DLWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dlwrf_JRA55=permute(dlwrf_JRA55,[2 1 3 4]);
   dlwrf_JRA55=reshape(dlwrf_JRA55,[332 316 8]);
   dlwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   dlwrf_JRA55(cloud_JRA55>20)=nan;
   data_dlwrf_JRA55(:,:,i)=mean(dlwrf_JRA55,3,'omitnan');
   % upward longwave
   ulwrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_ulwrf_all_polargrid.nc','ULWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   ulwrf_JRA55=permute(ulwrf_JRA55,[2 1 3 4]);
   ulwrf_JRA55=reshape(ulwrf_JRA55,[332 316 8]);
   ulwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   ulwrf_JRA55(cloud_JRA55>20)=nan;
   data_ulwrf_JRA55(:,:,i)=mean(ulwrf_JRA55,3,'omitnan');
   % sensible heat flux
   shtfl_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_shtfl_all_polargrid.nc','SHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   shtfl_JRA55=permute(shtfl_JRA55,[2 1 3 4]);
   shtfl_JRA55=reshape(shtfl_JRA55,[332 316 8]);
   shtfl_JRA55(isnan(data_satellite_JRA55))=nan;
   shtfl_JRA55(cloud_JRA55>20)=nan;
   data_shtfl_JRA55(:,:,i)=mean(shtfl_JRA55,3,'omitnan');
   % latent heat flux
   lhtfl_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_lhtfl_all_polargrid.nc','LHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   lhtfl_JRA55=permute(lhtfl_JRA55,[2 1 3 4]);
   lhtfl_JRA55=reshape(lhtfl_JRA55,[332 316 8]);
   lhtfl_JRA55(isnan(data_satellite_JRA55))=nan;
   lhtfl_JRA55(cloud_JRA55>20)=nan;
   data_lhtfl_JRA55(:,:,i)=mean(lhtfl_JRA55,3,'omitnan');


   time=time+1
end

for j=1:5
ERA5_dswrf_season{j}=mean(data_msdwswrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_uswrf_season{j}=mean(data_msuwswrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_dlwrf_season{j}=mean(data_msdwlwrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_ulwrf_season{j}=mean(data_msuwlwrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_shf_season{j}=mean(data_msshf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_lhf_season{j}=mean(data_mslhf_ERA5(:,:,X{j}),3,'omitnan');


JRA55_dswrf_season{j}=mean(data_dswrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_uswrf_season{j}=mean(data_uswrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_dlwrf_season{j}=mean(data_dlwrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_ulwrf_season{j}=mean(data_ulwrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_shf_season{j}=mean(data_shtfl_JRA55(:,:,X{j}),3,'omitnan');
JRA55_lhf_season{j}=mean(data_lhtfl_JRA55(:,:,X{j}),3,'omitnan');
end

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
save ERA5_radiation_clearsky_100SIC ERA5* data*ERA5 -v7.3
save JRA55_radiation_clearsky_100SIC JRA55* data*JRA55 -v7.3

clear

%%
%% plot SEB balance under 100% condition


cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice

load ERA5_radiation_100SIC.mat ERA5*

ERA5_dlwrf_season_allsky=ERA5_dlwrf_season;
ERA5_dswrf_season_allsky=ERA5_dswrf_season;
ERA5_lhf_season_allsky=ERA5_lhf_season;
ERA5_shf_season_allsky=ERA5_shf_season;
ERA5_ulwrf_season_allsky=ERA5_ulwrf_season;
ERA5_uswrf_season_allsky=ERA5_uswrf_season;

load ERA5_radiation_clearsky_100SIC.mat ERA5*
for i=1:5
ERA5_ulwrf_season{i}=-ERA5_ulwrf_season{i};
ERA5_uswrf_season{i}=-ERA5_uswrf_season{i};
ERA5_lhf_season{i}=-ERA5_lhf_season{i};
ERA5_shf_season{i}=-ERA5_shf_season{i};

ERA5_ulwrf_season_allsky{i}=-ERA5_ulwrf_season_allsky{i};
ERA5_uswrf_season_allsky{i}=-ERA5_uswrf_season_allsky{i};
ERA5_lhf_season_allsky{i}=-ERA5_lhf_season_allsky{i};
ERA5_shf_season_allsky{i}=-ERA5_shf_season_allsky{i};
end

load JRA55_radiation_100SIC.mat JRA55*
JRA55_dlwrf_season_allsky=JRA55_dlwrf_season;
JRA55_dswrf_season_allsky=JRA55_dswrf_season;
JRA55_lhf_season_allsky=JRA55_lhf_season;
JRA55_shf_season_allsky=JRA55_shf_season;
JRA55_ulwrf_season_allsky=JRA55_ulwrf_season;
JRA55_uswrf_season_allsky=JRA55_uswrf_season;

load JRA55_radiation_clearsky_100SIC.mat JRA55*
for i=1:5
JRA55_ulwrf_season{i}=-JRA55_ulwrf_season{i};
JRA55_uswrf_season{i}=-JRA55_uswrf_season{i};
JRA55_lhf_season{i}=-JRA55_lhf_season{i};
JRA55_shf_season{i}=-JRA55_shf_season{i};

JRA55_ulwrf_season_allsky{i}=-JRA55_ulwrf_season_allsky{i};
JRA55_uswrf_season_allsky{i}=-JRA55_uswrf_season_allsky{i};
JRA55_lhf_season_allsky{i}=-JRA55_lhf_season_allsky{i};
JRA55_shf_season_allsky{i}=-JRA55_shf_season_allsky{i};
end


load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
ERA5_dlwrf_season_domain=sum(ERA5_dlwrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dlwrf_season{1})),'all','omitnan');
ERA5_dswrf_season_domain=sum(ERA5_dswrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dswrf_season{1})),'all','omitnan');
ERA5_lhf_season_domain=sum(ERA5_lhf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_lhf_season{1})),'all','omitnan');
ERA5_shf_season_domain=sum(ERA5_shf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_shf_season{1})),'all','omitnan');
ERA5_ulwrf_season_domain=sum(ERA5_ulwrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ulwrf_season{1})),'all','omitnan');
ERA5_uswrf_season_domain=sum(ERA5_uswrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_uswrf_season{1})),'all','omitnan');

ERA5_dlwrf_season_domain_allsky=sum(ERA5_dlwrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dlwrf_season_allsky{1})),'all','omitnan');
ERA5_dswrf_season_domain_allsky=sum(ERA5_dswrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dswrf_season_allsky{1})),'all','omitnan');
ERA5_lhf_season_domain_allsky=sum(ERA5_lhf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_lhf_season_allsky{1})),'all','omitnan');
ERA5_shf_season_domain_allsky=sum(ERA5_shf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_shf_season_allsky{1})),'all','omitnan');
ERA5_ulwrf_season_domain_allsky=sum(ERA5_ulwrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ulwrf_season_allsky{1})),'all','omitnan');
ERA5_uswrf_season_domain_allsky=sum(ERA5_uswrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_uswrf_season_allsky{1})),'all','omitnan');


load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
JRA55_dlwrf_season_domain=sum(JRA55_dlwrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dlwrf_season{1})),'all','omitnan');
JRA55_dswrf_season_domain=sum(JRA55_dswrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dswrf_season{1})),'all','omitnan');
JRA55_lhf_season_domain=sum(JRA55_lhf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_lhf_season{1})),'all','omitnan');
JRA55_shf_season_domain=sum(JRA55_shf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_shf_season{1})),'all','omitnan');
JRA55_ulwrf_season_domain=sum(JRA55_ulwrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ulwrf_season{1})),'all','omitnan');
JRA55_uswrf_season_domain=sum(JRA55_uswrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_uswrf_season{1})),'all','omitnan');

JRA55_dlwrf_season_domain_allsky=sum(JRA55_dlwrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dlwrf_season_allsky{1})),'all','omitnan');
JRA55_dswrf_season_domain_allsky=sum(JRA55_dswrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dswrf_season_allsky{1})),'all','omitnan');
JRA55_lhf_season_domain_allsky=sum(JRA55_lhf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_lhf_season_allsky{1})),'all','omitnan');
JRA55_shf_season_domain_allsky=sum(JRA55_shf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_shf_season_allsky{1})),'all','omitnan');
JRA55_ulwrf_season_domain_allsky=sum(JRA55_ulwrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ulwrf_season_allsky{1})),'all','omitnan');
JRA55_uswrf_season_domain_allsky=sum(JRA55_uswrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_uswrf_season_allsky{1})),'all','omitnan');



figure
set(gcf,'unit','normalized','position',[.1 .08 .6 .85])

% now plot ERA5 SEB
ax3=axes('position',[0.1 0.1 .33 .60]); % [left bottom width height]
Y=[ERA5_dlwrf_season_domain,ERA5_dlwrf_season_domain_allsky,ERA5_dlwrf_season_domain-ERA5_dlwrf_season_domain_allsky;
       ERA5_ulwrf_season_domain,ERA5_ulwrf_season_domain_allsky,ERA5_ulwrf_season_domain-ERA5_ulwrf_season_domain_allsky;
       ERA5_lhf_season_domain,ERA5_lhf_season_domain_allsky,ERA5_lhf_season_domain-ERA5_lhf_season_domain_allsky;
       ERA5_shf_season_domain,ERA5_shf_season_domain_allsky,ERA5_shf_season_domain-ERA5_shf_season_domain_allsky;
       ERA5_dswrf_season_domain,ERA5_dswrf_season_domain_allsky,ERA5_dswrf_season_domain-ERA5_dswrf_season_domain_allsky;
       ERA5_uswrf_season_domain,ERA5_uswrf_season_domain_allsky,ERA5_uswrf_season_domain-ERA5_uswrf_season_domain_allsky;];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   xlim([-300 300]);
   %yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   %yticklabels({'\textit{L_d}','\textit{S_d}','\textit{F_{lh}}','\textit{F_{hs}}','\textit{L_u}','\textit{S_u}'})
   % 设置 y 轴刻度标签
   yticks = {'L_d','L_u','F_{lh}','F_{hs}','S_d','S_u'};
   set(gca, 'YTickLabel', yticks, 'FontAngle', 'italic');

   xlabel('Surface energy budget (W m^-^2)')
   legend('ERA5 with TCF mask','ERA5 without TCF mask ','With mask - Without mask');
   %legend('clear sky','all sky','clear sky - all sky')
   set(gca,'FontSize',18);
   text(-200,3,'Energy out','FontSize',20)
   text(100,3,'Energy in','FontSize',20)
   
    
    xtips3(1) = b(3).YEndPoints(1) -55;
    xtips3(5) = b(3).YEndPoints(5) + 5;
    xtips3(3) = b(3).YEndPoints(3) + 5;
    xtips3(4) = b(3).YEndPoints(4) + 5;
    xtips3(2) = b(3).YEndPoints(2) + 5;
    xtips3(6) = b(3).YEndPoints(6) - 55;

    ytips3 = b(3).XEndPoints;
    labels3 = string(roundn(b(3).YData,-2));
    text(xtips3,ytips3,labels3,'VerticalAlignment','middle','FontSize',15)

    % now plot the JRA55 SEB
 ax3=axes('position',[0.1+0.16+0.24 0.1 .33 .60]); % [left bottom width height]
Y=[JRA55_dlwrf_season_domain,JRA55_dlwrf_season_domain_allsky,JRA55_dlwrf_season_domain-JRA55_dlwrf_season_domain_allsky;
    JRA55_ulwrf_season_domain,JRA55_ulwrf_season_domain_allsky,JRA55_ulwrf_season_domain-JRA55_ulwrf_season_domain_allsky;       
    JRA55_lhf_season_domain,JRA55_lhf_season_domain_allsky,JRA55_lhf_season_domain-JRA55_lhf_season_domain_allsky;
       JRA55_shf_season_domain,JRA55_shf_season_domain_allsky,JRA55_shf_season_domain-JRA55_shf_season_domain_allsky;
       JRA55_dswrf_season_domain,JRA55_dswrf_season_domain_allsky,JRA55_dswrf_season_domain-JRA55_dswrf_season_domain_allsky;
       JRA55_uswrf_season_domain,JRA55_uswrf_season_domain_allsky,JRA55_uswrf_season_domain-JRA55_uswrf_season_domain_allsky;];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   %yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   %yticklabels({'L_d','S_d','F_{lh}','F_{hs}','L_u','S_u'} )
   % 设置 y 轴刻度标签
   yticks = {'L_d','L_u','F_{lh}','F_{hs}','S_d','S_u'};
   set(gca, 'YTickLabel', yticks, 'FontAngle', 'italic');
   
   xlim([-300 300]);
   xlabel('Surface energy budget (W m^-^2)')
   legend('JRA55 with TCF mask','JRA55 without TCF mask ','With mask - Without mask');
   %legend('clear sky','all sky','clear sky - all sky')
   set(gca,'FontSize',18);
   text(-200,3,'Energy out','FontSize',20)
   text(100,3,'Energy in','FontSize',20)
   
    xtips3(1) = b(3).YEndPoints(1) -45;
    xtips3(5) = b(3).YEndPoints(5) + 5;
    xtips3(3) = b(3).YEndPoints(3) + 5;
    xtips3(4) = b(3).YEndPoints(4) + 5;
    xtips3(2) = b(3).YEndPoints(2) + 5;
    xtips3(6) = b(3).YEndPoints(6) - 55;

    ytips3 = b(3).XEndPoints;
    labels3 = string(roundn(b(3).YData,-2));
    text(xtips3,ytips3,labels3,'VerticalAlignment','middle','FontSize',15)
    
    %manually change the text to the position when want 
    text(0.1, 0.7, '（a）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 18);
    text(0.1, 0.8, '（b）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 18);



    %% now we investigating the ice heat conduction under 100% SIC


clear
%date of each experiment
dates = datenum('01-Dec-2002'):datenum('30-Nov-2020');
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);

x0=(1:length(datevec))';
[x1,]=find(datevec(:,2)==8 | datevec(:,2)==9 | datevec(:,2)==10);
X={x0,x1};


time=1;
for i=1:length(x0)
   load(['/Volumes/ExtremePro/IST_SIC_80_100_2024/IST_Satellite_100SIC/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5 radiation 
   % downward shortwave 
   msdwswrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwswrf_all.nc','var35',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwswrf_ERA5=permute(msdwswrf_ERA5,[2 1 3]);
   msdwswrf_ERA5(isnan(data_satellite))=nan;
   msdwswrf_ERA5(msdwswrf_ERA5>10)=nan;
   data_msdwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5,3,'omitnan'); 
   % upward shortwave 
   msnswrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnswrf_all.nc','var37',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnswrf_ERA5=permute(msnswrf_ERA5,[2 1 3]);
   msnswrf_ERA5(isnan(data_satellite))=nan;
   msnswrf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_msuwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5-msnswrf_ERA5,3,'omitnan'); 
   % downward longwave 
   msdwlwrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwlwrf_all.nc','var36',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwlwrf_ERA5=permute(msdwlwrf_ERA5,[2 1 3]);
   msdwlwrf_ERA5(isnan(data_satellite))=nan;
   msdwlwrf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_msdwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5,3,'omitnan'); 
   % upward longwave 
   msnlwrf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnlwrf_all.nc','var38',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnlwrf_ERA5=permute(msnlwrf_ERA5,[2 1 3]);
   msnlwrf_ERA5(isnan(data_satellite))=nan;
   msnlwrf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_msuwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5-msnlwrf_ERA5,3,'omitnan'); 
   % sensible heat flux
   msshf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msshf_all.nc','var33',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msshf_ERA5=permute(msshf_ERA5,[2 1 3]);
   msshf_ERA5(isnan(data_satellite))=nan;
   msshf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_msshf_ERA5(:,:,i)=mean(-msshf_ERA5,3,'omitnan'); 
   % latent heat flux
   mslhf_ERA5=ncread('/Volumes/ExtremePro/Extreme_SSD/ERA5_radiation_polargrid/ERA5_mslhf_all.nc','var34',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   mslhf_ERA5=permute(mslhf_ERA5,[2 1 3]);
   mslhf_ERA5(isnan(data_satellite))=nan;
   mslhf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_mslhf_ERA5(:,:,i)=mean(-mslhf_ERA5,3,'omitnan'); 

   % JRA55 radiation   
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end   
   % downward shortwave
   dswrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dswrf_all_polargrid.nc','DSWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dswrf_JRA55=permute(dswrf_JRA55,[2 1 3 4]);
   dswrf_JRA55=reshape(dswrf_JRA55,[332 316 8]);
   dswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   dswrf_JRA55(dswrf_JRA55>10)=nan;
   data_dswrf_JRA55(:,:,i)=mean(dswrf_JRA55,3,'omitnan');
   % upward shortwave
   uswrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_uswrf_all_polargrid.nc','USWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   uswrf_JRA55=permute(uswrf_JRA55,[2 1 3 4]);
   uswrf_JRA55=reshape(uswrf_JRA55,[332 316 8]);
   uswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   uswrf_JRA55(isnan(dswrf_JRA55))=nan;
   data_uswrf_JRA55(:,:,i)=mean(uswrf_JRA55,3,'omitnan');
   % downward longwave 
   dlwrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dlwrf_all_polargrid.nc','DLWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dlwrf_JRA55=permute(dlwrf_JRA55,[2 1 3 4]);
   dlwrf_JRA55=reshape(dlwrf_JRA55,[332 316 8]);
   dlwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   dlwrf_JRA55(isnan(dswrf_JRA55))=nan;
   data_dlwrf_JRA55(:,:,i)=mean(dlwrf_JRA55,3,'omitnan');
   % upward longwave
   ulwrf_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_ulwrf_all_polargrid.nc','ULWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   ulwrf_JRA55=permute(ulwrf_JRA55,[2 1 3 4]);
   ulwrf_JRA55=reshape(ulwrf_JRA55,[332 316 8]);
   ulwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   ulwrf_JRA55(isnan(dswrf_JRA55))=nan;
   data_ulwrf_JRA55(:,:,i)=mean(ulwrf_JRA55,3,'omitnan');
   % sensible heat flux
   shtfl_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_shtfl_all_polargrid.nc','SHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   shtfl_JRA55=permute(shtfl_JRA55,[2 1 3 4]);
   shtfl_JRA55=reshape(shtfl_JRA55,[332 316 8]);
   shtfl_JRA55(isnan(data_satellite_JRA55))=nan;
   shtfl_JRA55(isnan(dswrf_JRA55))=nan;
   data_shtfl_JRA55(:,:,i)=mean(shtfl_JRA55,3,'omitnan');
   % latent heat flux
   lhtfl_JRA55=ncread('/Volumes/ExtremePro/Extreme_SSD/JRA55_radiation_polargrid/JRA55_lhtfl_all_polargrid.nc','LHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   lhtfl_JRA55=permute(lhtfl_JRA55,[2 1 3 4]);
   lhtfl_JRA55=reshape(lhtfl_JRA55,[332 316 8]);
   lhtfl_JRA55(isnan(data_satellite_JRA55))=nan;
   lhtfl_JRA55(isnan(dswrf_JRA55))=nan;
   data_lhtfl_JRA55(:,:,i)=mean(lhtfl_JRA55,3,'omitnan');


   time=time+1
end



for j=1:2
ERA5_dswrf_season{j}=mean(data_msdwswrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_uswrf_season{j}=mean(data_msuwswrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_dlwrf_season{j}=mean(data_msdwlwrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_ulwrf_season{j}=mean(data_msuwlwrf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_shf_season{j}=mean(data_msshf_ERA5(:,:,X{j}),3,'omitnan');
ERA5_lhf_season{j}=mean(data_mslhf_ERA5(:,:,X{j}),3,'omitnan');


JRA55_dswrf_season{j}=mean(data_dswrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_uswrf_season{j}=mean(data_uswrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_dlwrf_season{j}=mean(data_dlwrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_ulwrf_season{j}=mean(data_ulwrf_JRA55(:,:,X{j}),3,'omitnan');
JRA55_shf_season{j}=mean(data_shtfl_JRA55(:,:,X{j}),3,'omitnan');
JRA55_lhf_season{j}=mean(data_lhtfl_JRA55(:,:,X{j}),3,'omitnan');
end

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
save ERA5_radiation_less10w_100SIC ERA5* data*ERA5 -v7.3
save JRA55_radiation_less10w_100SIC JRA55* data*JRA55 -v7.3




% ﻿ice heat conduction term
i=2
R_ERA5=-(ERA5_uswrf_season{i}+ERA5_ulwrf_season{i}-ERA5_dswrf_season{i}-ERA5_dlwrf_season{i}+ERA5_lhf_season{1}+ERA5_shf_season{i});
R_JRA55=-(JRA55_uswrf_season{i}+JRA55_ulwrf_season{i}-JRA55_dswrf_season{i}-JRA55_dlwrf_season{i}+JRA55_lhf_season{i}+JRA55_shf_season{i});
R(:,:,1)=R_ERA5; R(:,:,2)=R_JRA55;

title_name={'Ice heat conduction in ERA5','Ice heat conduction in JRA55','Diff (ERA5 - JRA55)'};
text_all={'(a)','(b)','(c)','(d)'};
figure
[ha, pos] = tight_subplot(1,3,[.01 .02],[.01 .04],[.03 .03]);
for q=1:3
if q<3 
axes(ha(q));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,R(:,:,q));
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-100 100])
cmocean('balance',600)
title(title_name{q},'FontSize',18)
m_text(-43,-45,text_all{q},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','W m^-^2')
end

if q==3
axes(ha(q));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,R(:,:,2)-R(:,:,1));
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-50 50])
cmocean('balance',600)
title(title_name{q},'FontSize',18)
m_text(-43,-45,text_all{q},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','W m^-^2')
end
end

%% calculate the domain-averge ice heat conduction from model

 load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    ERA5_domain=sum(R(:,:,1).*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R(:,:,1))),'all','omitnan');
    JRA55_domain=sum(R(:,:,2).*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R(:,:,2))),'all','omitnan');
    Diff_domain=sum((R(:,:,1)-R(:,:,2)).*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R(:,:,1)-R(:,:,2))),'all','omitnan');

    %  -35.3039 for JRA55,  -47.8683 for ERA5, -12.5712 for diff



