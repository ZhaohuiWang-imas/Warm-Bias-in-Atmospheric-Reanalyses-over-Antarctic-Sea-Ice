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


cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')


%% now we calculate the average cloud cover of each reanalysis (JRA55 and ERA5) at the condition of clear sky MODIS data aviliable
for i=1:length(x0)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5
   % add cloud mask here
   cloud_ERA5=ncread('/Volumes/ExtremePro/WANG_SSD/ERA5_cloud/ERA5_cloudcover_all_polargrid.nc','var164',[1 1 8017+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   cloud_ERA5(isnan(data_satellite))=nan;
   data_cloud_ERA5_masked(:,:,i)=mean(cloud_ERA5,3,'omitnan'); 
   
   % MERRA2
   % add cloud mask here
   cloud_MERRA2=ncread('/Volumes/ExtremePro/WANG_SSD/MERRA2_cloud/MERRA2_cloudcover_all_polargrid.nc','CLDTOT',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_MERRA2=permute(cloud_MERRA2,[2 1 3]);
   cloud_MERRA2(isnan(data_satellite))=nan;
   data_cloud_MERRA2_masked(:,:,i)=mean(cloud_MERRA2,3,'omitnan'); 
   
   % NCEP2
   % add cloud mask here
   cloud_NCEPR2=ncread('/Volumes/ExtremePro/WANG_SSD/NCEPR2_cloud/NCEPR2_cloud_merge_polargrid.nc','tcdc',[1 1 1337+4*(i-1)],[Inf Inf 4]);
   cloud_NCEPR2=permute(cloud_NCEPR2,[2 1 3]);
   cloud_NCEPR2(isnan(data_satellite(:,:,1:6:end)))=nan;
   data_cloud_NCEPR2_masked(:,:,i)=mean(cloud_NCEPR2,3,'omitnan'); 
   
   % ERAI
   if i<=6118
   % add cloud mask here
   cloud_ERAI=ncread('/Volumes/ExtremePro/WANG_SSD/ERAI_cloud/ERAI_cloudcover_all_polargrid.nc','tcc',[1 1 1337+4*(i-1)],[Inf Inf 4]);
   cloud_ERAI=permute(cloud_ERAI,[2 1 3]);
   cloud_ERAI(isnan(data_satellite(:,:,1:6:end)))=nan;
   data_cloud_ERAI_masked(:,:,i)=mean(cloud_ERAI,3,'omitnan'); 
   end

   % JRA55
   % add cloud mask here
   cloud_JRA55=ncread('/Volumes/ExtremePro/WANG_SSD/JRA55_cloud/JRA55_cloud_merge_polargrid.nc','TCDC_GDS4_ISBY',[1 1 2673+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   cloud_JRA55(isnan(data_satellite_JRA55))=nan;
   data_cloud_JRA55_masked(:,:,i)=mean(cloud_JRA55,3,'omitnan'); 
   i
end

%seasonal cloud (masked with model)
for j=1:5
ERA5_ME_season=mean(data_cloud_ERA5_masked(:,:,X{j}),3,'omitnan');
ERA5_ME_masked{j}=ERA5_ME_season;
JRA55_ME_season=mean(data_cloud_JRA55_masked(:,:,X{j}),3,'omitnan');
JRA55_ME_masked{j}=JRA55_ME_season./100;
MERRA2_ME_season=mean(data_cloud_MERRA2_masked(:,:,X{j}),3,'omitnan');
MERRA2_ME_masked{j}=MERRA2_ME_season;
ERAI_ME_season=mean(data_cloud_ERAI_masked(:,:,X{j}(X{j}<6117)),3,'omitnan');
ERAI_ME_masked{j}=ERAI_ME_season;
NCEPR2_ME_season=mean(data_cloud_NCEPR2_masked(:,:,X{j}),3,'omitnan');
NCEPR2_ME_masked{j}=NCEPR2_ME_season./100;
end

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
save cloud_fra_clear_sky.mat *_ME_masked