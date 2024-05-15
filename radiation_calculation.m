% this programming used to analysis the radiation difference between ERA5
% and JRA55, also used to investigate the difference after applying the
% cloud filter from reanalyses


% JRA55 is 3 hourly reanalysis while ERA5 is hourly reanalysis
% Parameters in JRA55 radiation are averaged from the beginning of 
% forecasts through 3 hours for 00-03, 06-09, 12-15 and 18-21UTC, and 
% from 3 through 6 hours for 03-06, 09-12, 15-18 and 21-24UTC.
% Dates in filenames indicate the beginning of the averaging period

% ERA5, the processing period is over the 1 hour ending at the validity date and time

% so we need to average the hourly mean radiation of ERA5 to 3 hourly for
% comparision with JRA55


% for modis data  first file is 0~1 UTC, last one is 23~24 UTC

% there are two methods for doing this analysis

% First one is do as we have done for IST: calculate ERA5 firstly with
% Hourly, then do JRA55 for averaged the modis every three hours

% Second one is calculated the ERA5 to 3 hourly and then compared with
% JRA55

%% downward longwave radiation difference between ERA5 and JRA55

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
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
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
save ERA5_radiation ERA5* data*ERA5 -v7.3
save JRA55_radiation JRA55* data*JRA55 -v7.3

figure
[ha, pos] = tight_subplot(5,6,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf','shf','lhf'};
season={'ALL','JFM','AMJ','JAS','OND'};
q=1;
for i=1:5
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['ERA5_',data_name{j},'_season{i}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-300 300])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if i==1
         title(data_name{j},'FontSize',16)
        end
        if j==1
         ylabel(season{i},'FontSize',16)
        end
    end
end

figure
[ha, pos] = tight_subplot(5,6,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf','shf','lhf'};
season={'ALL','JFM','AMJ','JAS','OND'};
q=1;
for i=1:5
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['JRA55_',data_name{j},'_season{i}','-','JRA55_',data_name{j},'_season_allsky{i}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-100 100])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if i==1
         title(data_name{j},'FontSize',16)
        end
        if j==1
         ylabel(season{i},'FontSize',16)
        end
    end
end

figure
[ha, pos] = tight_subplot(5,3,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf'};
season={'ALL','JFM','AMJ','JAS','OND'};
title_name={'ERA5 up sw - down sw','ERA5 up lw - down lw','ERA5 net'};
q=1;
for i=1:5
    for j=1:3
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        if j==3
        m_pcolor(lons,lats,eval(['ERA5_uswrf_season{i}','+','ERA5_ulwrf_season{i}','-','ERA5_dswrf_season{i}','-','ERA5_dlwrf_season{i}']));
        else
        m_pcolor(lons,lats,eval(['ERA5_',data_name{2*j},'_season{i}','-','ERA5_',data_name{2*j-1},'_season{i}']));
        end
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-100 100])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if i==1
         title(title_name{j},'FontSize',16)
        end
        if j==1
         ylabel(season{i},'FontSize',16)
        end
    end
end


%% clear sky

time=1;
for i=1:length(x0)
   load(['/Volumes/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % add cloud mask here
   cloud_ERA5=ncread('/Volumes/WANG_SSD/ERA5_cloud/ERA5_cloudcover_all_polargrid.nc','var164',[1 1 8017+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
 
   % ERA5 radiation 
   % downward shortwave 
   msdwswrf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwswrf_all.nc','var35',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwswrf_ERA5=permute(msdwswrf_ERA5,[2 1 3]);
   msdwswrf_ERA5(isnan(data_satellite))=nan;
   msdwswrf_ERA5(cloud_ERA5>0.2)=nan;
   data_msdwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5,3,'omitnan'); 
   % upward shortwave 
   msnswrf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnswrf_all.nc','var37',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnswrf_ERA5=permute(msnswrf_ERA5,[2 1 3]);
   msnswrf_ERA5(isnan(data_satellite))=nan;
   msnswrf_ERA5(cloud_ERA5>0.2)=nan;
   data_msuwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5-msnswrf_ERA5,3,'omitnan'); 
   % downward longwave 
   msdwlwrf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwlwrf_all.nc','var36',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwlwrf_ERA5=permute(msdwlwrf_ERA5,[2 1 3]);
   msdwlwrf_ERA5(isnan(data_satellite))=nan;
   msdwlwrf_ERA5(cloud_ERA5>0.2)=nan;
   data_msdwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5,3,'omitnan'); 
   % upward longwave 
   msnlwrf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnlwrf_all.nc','var38',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnlwrf_ERA5=permute(msnlwrf_ERA5,[2 1 3]);
   msnlwrf_ERA5(isnan(data_satellite))=nan;
   msnlwrf_ERA5(cloud_ERA5>0.2)=nan;
   data_msuwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5-msnlwrf_ERA5,3,'omitnan'); 
   % sensible heat flux
   msshf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msshf_all.nc','var33',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msshf_ERA5=permute(msshf_ERA5,[2 1 3]);
   msshf_ERA5(isnan(data_satellite))=nan;
   msshf_ERA5(cloud_ERA5>0.2)=nan;
   data_msshf_ERA5(:,:,i)=mean(-msshf_ERA5,3,'omitnan'); 
   % latent heat flux
   mslhf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_mslhf_all.nc','var34',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   mslhf_ERA5=permute(mslhf_ERA5,[2 1 3]);
   mslhf_ERA5(isnan(data_satellite))=nan;
   mslhf_ERA5(cloud_ERA5>0.2)=nan;
   data_mslhf_ERA5(:,:,i)=mean(-mslhf_ERA5,3,'omitnan'); 

   % JRA55 radiation   
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end   
   % add cloud mask here
   cloud_JRA55=ncread('/Volumes/WANG_SSD/JRA55_cloud/JRA55_cloud_merge_polargrid.nc','TCDC_GDS4_ISBY',[1 1 2673+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);

   % downward shortwave
   dswrf_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dswrf_all_polargrid.nc','DSWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dswrf_JRA55=permute(dswrf_JRA55,[2 1 3 4]);
   dswrf_JRA55=reshape(dswrf_JRA55,[332 316 8]);
   dswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   dswrf_JRA55(cloud_JRA55>20)=nan;
   data_dswrf_JRA55(:,:,i)=mean(dswrf_JRA55,3,'omitnan');
   % upward shortwave
   uswrf_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_uswrf_all_polargrid.nc','USWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   uswrf_JRA55=permute(uswrf_JRA55,[2 1 3 4]);
   uswrf_JRA55=reshape(uswrf_JRA55,[332 316 8]);
   uswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   uswrf_JRA55(cloud_JRA55>20)=nan;
   data_uswrf_JRA55(:,:,i)=mean(uswrf_JRA55,3,'omitnan');
   % downward longwave 
   dlwrf_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dlwrf_all_polargrid.nc','DLWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dlwrf_JRA55=permute(dlwrf_JRA55,[2 1 3 4]);
   dlwrf_JRA55=reshape(dlwrf_JRA55,[332 316 8]);
   dlwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   dlwrf_JRA55(cloud_JRA55>20)=nan;
   data_dlwrf_JRA55(:,:,i)=mean(dlwrf_JRA55,3,'omitnan');
   % upward longwave
   ulwrf_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_ulwrf_all_polargrid.nc','ULWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   ulwrf_JRA55=permute(ulwrf_JRA55,[2 1 3 4]);
   ulwrf_JRA55=reshape(ulwrf_JRA55,[332 316 8]);
   ulwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   ulwrf_JRA55(cloud_JRA55>20)=nan;
   data_ulwrf_JRA55(:,:,i)=mean(ulwrf_JRA55,3,'omitnan');
   % sensible heat flux
   shtfl_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_shtfl_all_polargrid.nc','SHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   shtfl_JRA55=permute(shtfl_JRA55,[2 1 3 4]);
   shtfl_JRA55=reshape(shtfl_JRA55,[332 316 8]);
   shtfl_JRA55(isnan(data_satellite_JRA55))=nan;
   shtfl_JRA55(cloud_JRA55>20)=nan;
   data_shtfl_JRA55(:,:,i)=mean(shtfl_JRA55,3,'omitnan');
   % latent heat flux
   lhtfl_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_lhtfl_all_polargrid.nc','LHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
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

save ERA5_radiation_clearsky ERA5* data*ERA5 -v7.3
save JRA55_radiation_clearsky JRA55* data*JRA55 -v7.3

clear

%%
%%
figure
[ha, pos] = tight_subplot(5,3,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf'};
season={'ALL','JFM','AMJ','JAS','OND'};
title_name={'ERA5 up sw - down sw','ERA5 up lw - down lw','ERA5 net'};
q=1;
for i=1:5
    for j=1:3
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        if j==3
        m_pcolor(lons,lats,eval(['ERA5_uswrf_season{i}','+','ERA5_ulwrf_season{i}','-','ERA5_dswrf_season{i}','-','ERA5_dlwrf_season{i}']));
        else
        m_pcolor(lons,lats,eval(['ERA5_',data_name{2*j},'_season{i}','-','ERA5_',data_name{2*j-1},'_season{i}']));
        end
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-100 100])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if i==1
         title(title_name{j},'FontSize',16)
        end
        if j==1
         ylabel(season{i},'FontSize',16)
        end
    end
end



%% Figure in SEB section 1
for i=1:5
ERA5_ulwrf_season{i}=-ERA5_ulwrf_season{i};
ERA5_uswrf_season{i}=-ERA5_uswrf_season{i};
ERA5_lhf_season{i}=-ERA5_lhf_season{i};
ERA5_shf_season{i}=-ERA5_shf_season{i};

JRA55_ulwrf_season{i}=-JRA55_ulwrf_season{i};
JRA55_uswrf_season{i}=-JRA55_uswrf_season{i};
JRA55_lhf_season{i}=-JRA55_lhf_season{i};
JRA55_shf_season{i}=-JRA55_shf_season{i};
end


figure
[ha, pos] = tight_subplot(3,6,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf','shf','lhf'};
season={'ERA5','JRA55','JRA55 - ERA5'};
q=1;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['ERA5_',data_name{j},'_season{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-300 300])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
         title(data_name{j},'FontSize',16)
        if j==1
         ylabel(season{1},'FontSize',16)
        end
    end

    q=7;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['JRA55_',data_name{j},'_season{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-300 300])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if j==1
         ylabel(season{2},'FontSize',16)
        end
    end

    q=13;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['JRA55_',data_name{j},'_season{1}','-','ERA5_',data_name{j},'_season{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if j==1
         ylabel(season{3},'FontSize',16)
        end
    end


    %% Figure in SEB section 2

figure
[ha, pos] = tight_subplot(3,6,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf','shf','lhf'};
season={'ERA5 no TCC mask','ERA5 - TCC mask','ERA5 mask - no mask'};
q=1;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['ERA5_',data_name{j},'_season_allsky{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-300 300])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
         title(data_name{j},'FontSize',16)
        if j==1
         ylabel(season{1},'FontSize',16)
        end
    end

    q=7;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['ERA5_',data_name{j},'_season{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-300 300])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if j==1
         ylabel(season{2},'FontSize',16)
        end
    end

    q=13;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['ERA5_',data_name{j},'_season{1}','-','ERA5_',data_name{j},'_season_allsky{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if j==1
         ylabel(season{3},'FontSize',16)
        end
    end

    %% Figure in SEB section 3

figure
[ha, pos] = tight_subplot(3,6,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf','shf','lhf'};
season={'ERA5','JRA55','JRA55 - ERA5'};
q=1;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['ERA5_',data_name{j},'_season{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-300 300])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
         title(data_name{j},'FontSize',16)
        if j==1
         ylabel(season{1},'FontSize',16)
        end
    end

    q=7;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['JRA55_',data_name{j},'_season{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-300 300])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if j==1
         ylabel(season{2},'FontSize',16)
        end
    end

    q=13;
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_pcolor(lons,lats,eval(['JRA55_',data_name{j},'_season{1}','-','ERA5_',data_name{j},'_season{1}']));
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        if j==1
         ylabel(season{3},'FontSize',16)
        end
    end

    %% plot the net difference figure

figure
[ha, pos] = tight_subplot(3,3,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf'};
title_name={'ERA5 shortwave net','ERA5 longwave net','ERA5 radiation flux net'};
season={'ERA5 no TCC mask','ERA5 with TCC mask','ERA5 mask - no mask'};
q=1;
    for j=1:3
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        if j==3
        m_pcolor(lons,lats,eval(['ERA5_uswrf_season_allsky{1}','+','ERA5_ulwrf_season_allsky{1}','-','ERA5_dswrf_season_allsky{1}','-','ERA5_dlwrf_season_allsky{1}']));
        else
        m_pcolor(lons,lats,eval(['ERA5_',data_name{2*j},'_season_allsky{1}','-','ERA5_',data_name{2*j-1},'_season_allsky{1}']));
        end
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-100 100])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
       
         title(title_name{j},'FontSize',16)
        
        if j==1
         ylabel(season{1},'FontSize',16)
        end
    end

q=4;
    for j=1:3
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        if j==3
        m_pcolor(lons,lats,eval(['ERA5_uswrf_season{1}','+','ERA5_ulwrf_season{1}','-','ERA5_dswrf_season{1}','-','ERA5_dlwrf_season{1}']));
        else
        m_pcolor(lons,lats,eval(['ERA5_',data_name{2*j},'_season{1}','-','ERA5_',data_name{2*j-1},'_season{1}']));
        end
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-100 100])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
       
         title(title_name{j},'FontSize',16)
        
        if j==1
         ylabel(season{2},'FontSize',16)
        end
    end

title_name={'ERA5 shortwave net diff','ERA5 longwave net diff','ERA5 radiation flux net diff'};
    q=7;
    for j=1:3
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        if j==3
        m_pcolor(lons,lats,(ERA5_uswrf_season{1}+ERA5_ulwrf_season{1}-ERA5_dswrf_season{1}-ERA5_dlwrf_season{1})-(ERA5_uswrf_season_allsky{1}+ERA5_ulwrf_season_allsky{1}-ERA5_dswrf_season_allsky{1}-ERA5_dlwrf_season_allsky{1}));
        else
        m_pcolor(lons,lats,eval(['ERA5_',data_name{2*j},'_season{1}','-','ERA5_',data_name{2*j-1},'_season{1}','-','ERA5_',data_name{2*j},'_season_allsky{1}','+','ERA5_',data_name{2*j-1},'_season_allsky{1}']));
        end
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
       
         title(title_name{j},'FontSize',16)
        
        if j==1
         ylabel(season{3},'FontSize',16)
        end
    end

%% Figure in SEB section 2.1 ERA5 before and after cloud mask - net heat diff and IST diff

figure
[ha, pos] = tight_subplot(2,2,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf','shf','lhf'};
q=1;
data_name={'dswrf', 'uswrf','dlwrf','ulwrf'};
season={'ERA5 no TCC mask','ERA5 with TCC mask','ERA5 mask - no mask'};
title_name={'ERA5 net shortwave diff','ERA5 net longwave diff','ERA5 net radiation flux diff', 'ERA5 IST bias diff'};
    q=1;
    for j=1:3
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        if j==3
        m_pcolor(lons,lats,(ERA5_uswrf_season{1}+ERA5_ulwrf_season{1}-ERA5_dswrf_season{1}-ERA5_dlwrf_season{1})-(ERA5_uswrf_season_allsky{1}+ERA5_ulwrf_season_allsky{1}-ERA5_dswrf_season_allsky{1}-ERA5_dlwrf_season_allsky{1}));
        else
        m_pcolor(lons,lats,eval(['ERA5_',data_name{2*j},'_season{1}','-','ERA5_',data_name{2*j-1},'_season{1}','-','ERA5_',data_name{2*j},'_season_allsky{1}','+','ERA5_',data_name{2*j-1},'_season_allsky{1}']));
        end
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
       
         title(title_name{j},'FontSize',16)
        
        if j==1
         ylabel(season{3},'FontSize',16)
        end
    end

axes(ha(4));
load('data_ME.mat', 'data_ME_ERA5')
ERA5_ME=mean(data_ME_ERA5,3,'omitnan');
load('data_ME_02cloud.mat', 'data_ME_ERA5')
ERA5_ME_clearsky=mean(data_ME_ERA5,3,'omitnan');

m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,(ERA5_ME_clearsky-ERA5_ME));
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        cmocean('balance',30)
caxis([-5 5])
title(title_name{4},'FontSize',16)

%correlation in net longwave diff and IST bias diff

a=-(ERA5_ME_clearsky-ERA5_ME);
a=reshape(a,[332*316 1]);
j=2;
b=eval(['ERA5_',data_name{2*j},'_season{1}','-','ERA5_',data_name{2*j-1},'_season{1}','-','ERA5_',data_name{2*j},'_season_allsky{1}','+','ERA5_',data_name{2*j-1},'_season_allsky{1}']);
b=reshape(b,[332*316 1]);
[rho,pval] = corr(a_nonan,b_nonan,'Type','Pearson'); 


%% Figure in SEB section 3.1 JRA55 and ERA5 after cloud mask - net heat diff 
figure
[ha, pos] = tight_subplot(2,2,[.01 .01],[.01 .04],[.03 .03]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf','shf','lhf'};
season={'ERA5','JRA55','JRA55 - ERA5'};
q=1;
data_name={'dswrf', 'uswrf','dlwrf','ulwrf'};
title_name={'net shortwave diff(JRA55-ERA5)','net longwave diff(JRA55-ERA5)','net radiation flux diff(JRA55-ERA5)', 'Net turbulent flux diff(JRA55-ERA5)'};
    q=1;
    for j=1:4
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        if j==3
        m_pcolor(lons,lats,(JRA55_uswrf_season{1}+JRA55_ulwrf_season{1}-JRA55_dswrf_season{1}-JRA55_dlwrf_season{1})-(ERA5_uswrf_season{1}+ERA5_ulwrf_season{1}-ERA5_dswrf_season{1}-ERA5_dlwrf_season{1}));
        elseif j==4
        m_pcolor(lons,lats,(JRA55_lhf_season{1}+JRA55_shf_season{1})-(ERA5_lhf_season{1}+ERA5_shf_season{1})); 
        else
        m_pcolor(lons,lats,eval(['JRA55_',data_name{2*j},'_season{1}','-','JRA55_',data_name{2*j-1},'_season{1}','-','ERA5_',data_name{2*j},'_season{1}','+','ERA5_',data_name{2*j-1},'_season{1}']));
        end
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',600)
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        colorbar
         title(title_name{j},'FontSize',16)
    end

% ﻿ice heat conduction term
i=2
R_ERA5=-(ERA5_uswrf_season{i}+ERA5_ulwrf_season{i}-ERA5_dswrf_season{i}-ERA5_dlwrf_season{i}+ERA5_lhf_season{1}+ERA5_shf_season{i});
R_JRA55=-(JRA55_uswrf_season{i}+JRA55_ulwrf_season{i}-JRA55_dswrf_season{i}-JRA55_dlwrf_season{i}+JRA55_lhf_season{i}+JRA55_shf_season{i});
R(:,:,1)=R_ERA5; R(:,:,2)=R_JRA55;
title_name={'ice heat conduction in ERA5','ice heat conduction in JRA55','diff (ERA5 - JRA55)'};
figure
[ha, pos] = tight_subplot(1,3,[.01 .01],[.01 .04],[.03 .03]);
for q=1:3
if q<3 
axes(ha(q));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,R(:,:,q));
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-100 100])
cmocean('balance',600)
title(title_name{q},'FontSize',16)
colorbar
end

if q==3
axes(ha(q));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,R(:,:,2)-R(:,:,1));
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-50 50])
cmocean('balance',600)
title(title_name{q},'FontSize',16)
colorbar
end
end


R_JRA55=-(data_uswrf_JRA55+data_ulwrf_JRA55-data_dswrf_JRA55-data_dlwrf_JRA55+data_lhtfl_JRA55+data_shtfl_JRA55);
mean_R_ERA5=mean(R_JRA55,3,'omitnan');
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,mean_R_ERA5);
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-100 100])
cmocean('balance',600)



%% investigation why warm biases reduction is higher in summer than winter?
load('/Volumes/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
%% Plots of the average (2002-2020) domain averaged temperture for each day (k).
for day = 1:365
 x=find(datevec(:,2)==datevec(day,2) & datevec(:,3)==datevec(day,3));
 
 msdwlwrf_ERA5_dailyME(:,:,day)=nanmean(data_msdwlwrf_ERA5(:,:,x),3); 
 msdwswrf_ERA5_dailyME(:,:,day)=nanmean(data_msdwswrf_ERA5(:,:,x(x<=6118)),3); 
 mslhf_ERA5_dailyME(:,:,day)=nanmean(data_mslhf_ERA5(:,:,x),3); 
 msshf_ERA5_dailyME(:,:,day)=nanmean(data_msshf_ERA5(:,:,x),3); 
 msuwlwrf_ERA5_dailyME(:,:,day)=nanmean(data_msuwlwrf_ERA5(:,:,x),3); 
 msuwswrf_ERA5_dailyME(:,:,day)=nanmean(data_msuwswrf_ERA5(:,:,x),3); 
end

for i=1:365
msdwlwrf_cloud(i)=nansum(msdwlwrf_ERA5_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(msdwlwrf_ERA5_dailyME(:,:,i))),'all');
msdwswrf_cloud(i)=nansum(msdwswrf_ERA5_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(msdwswrf_ERA5_dailyME(:,:,i))),'all');
mslhf_cloud(i)=nansum(mslhf_ERA5_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(mslhf_ERA5_dailyME(:,:,i))),'all');
msshf_cloud(i)=nansum(msshf_ERA5_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(msshf_ERA5_dailyME(:,:,i))),'all');
msuwlwrf_cloud(i)=nansum(msuwlwrf_ERA5_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(msuwlwrf_ERA5_dailyME(:,:,i))),'all');
msuwswrf_cloud(i)=nansum(msuwswrf_ERA5_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(msuwswrf_ERA5_dailyME(:,:,i))),'all');
end


figure
hold on
plot(1:365,msdwlwrf_cloud,'LineWidth',2)
plot(1:365,msdwswrf_cloud,'LineWidth',2)
plot(1:365,mslhf_cloud,'LineWidth',2)
plot(1:365,msshf_cloud,'LineWidth',2)
plot(1:365,msuwlwrf_cloud,'LineWidth',2)
plot(1:365,msuwswrf_cloud,'LineWidth',2)
hold off
legend('msdwlwrf_cloud','msdwswrf_cloud','mslhf_cloud','msshf_cloud','msuwlwrf_cloud','msuwswrf_cloud');
xticks([31,62,90,121,151,182,212,243,274,304,335,365])
xticklabels({'Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov'})
xlim([1 365])
set(gca,'FontSize',22);
ylim([-50 350])

figure
hold on
plot(1:365,msdwlwrf,'LineWidth',2)
plot(1:365,msdwswrf,'LineWidth',2)
plot(1:365,mslhf,'LineWidth',2)
plot(1:365,msshf,'LineWidth',2)
plot(1:365,msuwlwrf,'LineWidth',2)
plot(1:365,msuwswrf,'LineWidth',2)
hold off
legend('msdwlwrf','msdwswrf','mslhf','msshf','msuwlwrf','msuwswrf');
xticks([31,62,90,121,151,182,212,243,274,304,335,365])
xticklabels({'Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov'})
xlim([1 365])
set(gca,'FontSize',22);
ylim([-50 350])


figure
hold on
plot(1:365,msdwlwrf-msdwlwrf_cloud,'LineWidth',2)
plot(1:365,msdwswrf-msdwswrf_cloud,'LineWidth',2)
plot(1:365,mslhf-mslhf_cloud,'LineWidth',2)
plot(1:365,msshf-msshf_cloud,'LineWidth',2)
plot(1:365,msuwlwrf-msuwlwrf_cloud,'LineWidth',2)
plot(1:365,msuwswrf-msuwswrf_cloud,'LineWidth',2)
hold off
legend('dwl','dws','mslhf','msshf','uwl','uws');
xticks([31,62,90,121,151,182,212,243,274,304,335,365])
xticklabels({'Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov'})
xlim([1 365])
set(gca,'FontSize',22);
ylim([-100 150])


%% WRF dynamic downscaled Ground heat flux (ice conduction) from ERA5

clear
%date of each experiment
dates = datenum('02-Jan-2018'):datenum('03-Jan-2019');
datestring = datestr(dates, 'yyyymmdd');
datevect=datevec(dates);

datestring=[datestring(1:274,:);datestring(279:end,:)]; % 29Nov2023: change end to a correct end date number
datevect=[datevect(1:274,:);datevect(279:end,:)];

x0=(1:length(datevect))';
[x1,]=find(datevect(:,2)==3 | datevect(:,2)==1 | datevect(:,2)==2);
[x2,]=find(datevect(:,2)==6 | datevect(:,2)==4 | datevect(:,2)==5);
[x3,]=find(datevect(:,2)==9 | datevect(:,2)==7 | datevect(:,2)==8);
[x4,]=find(datevect(:,2)==12 | datevect(:,2)==10 | datevect(:,2)==11);
X={x0,x1,x2,x3,x4};

% load WRF ground heat flux (ice heat conduction)
 data=ncread('GRDFLX_only_nosnow_20_polargrid.nc','GRDFLX');
 GRDFLX_20=permute(data,[2 1 3]);
 data=ncread('GRDFLX_only_nosnow_15_polargrid.nc','GRDFLX');
 GRDFLX_15=permute(data,[2 1 3]);

 data=ncread('GRDFLX_nosnow_20_polargrid.nc','SEAICE');
 SEAICE_20=permute(data,[2 1 3]);
 data=ncread('GRDFLX_nosnow_15_polargrid.nc','SEAICE');
 SEAICE_15=permute(data,[2 1 3]);

%  data=ncread('GRDFLX_20_polargrid.nc','GRDFLX');
%  GRDFLX_20=permute(data,[2 1 3]);
%  data=ncread('GRDFLX_10_polargrid.nc','GRDFLX');
%  GRDFLX_15=permute(data,[2 1 3]);


for i=1:length(x0)
   load(['/Volumes/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   % ERA5 radiation 
   % 
   GRDFLX_ERA5_15=GRDFLX_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   GRDFLX_ERA5_15(isnan(data_satellite))=nan;
   data_GRDFLX_ERA5_15(:,:,i)=mean((GRDFLX_ERA5_15),3,'omitnan'); 

   GRDFLX_ERA5_20=GRDFLX_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   GRDFLX_ERA5_20(isnan(data_satellite))=nan;
   data_GRDFLX_ERA5_20(:,:,i)=mean((GRDFLX_ERA5_20),3,'omitnan'); 
end

for j=1:5
data_GRDFLX_ERA5_15_season{j}=mean(data_GRDFLX_ERA5_15(:,:,X{j}),3,'omitnan');
data_GRDFLX_ERA5_20_season{j}=mean(data_GRDFLX_ERA5_20(:,:,X{j}),3,'omitnan');
end

title_name={'ice heat conduction in ERA5 1m','ice heat conduction in ERA5 2m'};
figure
[ha, pos] = tight_subplot(1,3,[.01 .01],[.01 .04],[.03 .03]);
axes(ha(1));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,-data_GRDFLX_ERA5_15_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-100 100])
cmocean('balance',600)
title(title_name{1},'FontSize',16)
colorbar
axes(ha(2));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,-data_GRDFLX_ERA5_20_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-100 100])
cmocean('balance',600)
title(title_name{2},'FontSize',16)
colorbar
axes(ha(3));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_GRDFLX_ERA5_15_season{1}-data_GRDFLX_ERA5_20_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-20 20])
cmocean('balance',600)
title(title_name{2},'FontSize',16)
colorbar

%% Check the IST 

data=ncread('/Volumes/Extreme_SSD/GRDFLX_test/GRDFLX_nosnow_20_polargrid.nc','TSK');
TSK_20_nosnow_binary=permute(data,[2 1 3]);
data=ncread('/Volumes/Extreme_SSD/GRDFLX_test/GRDFLX_nosnow_15_polargrid.nc','TSK');
TSK_15_nosnow_frac=permute(data,[2 1 3]);
data=ncread('/Volumes/Extreme_SSD/GRDFLX_test/SEB_var_nosnow_2m_frac/SEB_var_nosnow_2m_frac_polargrid.nc','TSK');
TSK_nosnow_2m_frac=permute(data,[2 1 3]);
data=ncread('/Volumes/Extreme_SSD/SIT_2018_daily/SIT_15/TSK_15_polargrid.nc','TSK');
TSK_5cmsnow_15_frac=permute(data,[2 1 3]);
TSK_5cmsnow_15_frac=cat(3,TSK_5cmsnow_15_frac(:,:,1:(274*24)),TSK_5cmsnow_15_frac(:,:,(278*24+1):end));



for i=1:length(x0)
   load(['/Volumes/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   % 
   TSK_15_nosnow_frac_r=TSK_15_nosnow_frac(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   TSK_15_nosnow_frac_r(isnan(data_satellite))=nan;
   data_TSK_15_nosnow_frac(:,:,i)=mean((TSK_15_nosnow_frac_r-data_satellite),3,'omitnan'); 

   TSK_20_nosnow_binary_r=TSK_20_nosnow_binary(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   TSK_20_nosnow_binary_r(isnan(data_satellite))=nan;
   data_TSK_20_nosnow_binary(:,:,i)=mean((TSK_20_nosnow_binary_r-data_satellite),3,'omitnan'); 
end

for j=1:5
data_TSK_15_nosnow_frac_season{j}=mean(data_TSK_15_nosnow_frac(:,:,X{j}),3,'omitnan');
data_TSK_20_nosnow_binary_season{j}=mean(data_TSK_20_nosnow_binary(:,:,X{j}),3,'omitnan');
end

title_name={'Quasi-ERA5','Quasi-JRA55','Quasi-ERA5 - Quasi-JRA55'};
figure
[ha, pos] = tight_subplot(1,3,[.01 .01],[.01 .04],[.03 .03]);
axes(ha(1));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_TSK_15_nosnow_frac_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-15 15])
cmocean('balance',600)
title(title_name{1},'FontSize',16)
colorbar
axes(ha(2));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_TSK_20_nosnow_binary_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-15 15])
cmocean('balance',600)
title(title_name{2},'FontSize',16)
colorbar
axes(ha(3));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_TSK_15_nosnow_frac_season{1}-data_TSK_20_nosnow_binary_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600)
title(title_name{2},'FontSize',16)
colorbar


% IST difference between 4 experiment
for i=1:length(x0)
   load(['/Volumes/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   % 
   TSK_15_nosnow_frac_r=TSK_15_nosnow_frac(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   TSK_15_nosnow_frac_r(isnan(data_satellite))=nan;
   data_TSK_15_nosnow_frac(:,:,i)=mean((TSK_15_nosnow_frac_r-data_satellite),3,'omitnan'); 

   TSK_20_nosnow_binary_r=TSK_20_nosnow_binary(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   TSK_20_nosnow_binary_r(isnan(data_satellite))=nan;
   data_TSK_20_nosnow_binary(:,:,i)=mean((TSK_20_nosnow_binary_r-data_satellite),3,'omitnan'); 

   TSK_nosnow_2m_frac_r=TSK_nosnow_2m_frac(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   TSK_nosnow_2m_frac_r(isnan(data_satellite))=nan;
   data_TSK_nosnow_2m_frac(:,:,i)=mean((TSK_nosnow_2m_frac_r-data_satellite),3,'omitnan'); 

   TSK_5cmsnow_15_frac_r=TSK_5cmsnow_15_frac(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   TSK_5cmsnow_15_frac_r(isnan(data_satellite))=nan;
   data_TSK_5cmsnow_15_frac(:,:,i)=mean((TSK_5cmsnow_15_frac_r-data_satellite),3,'omitnan'); 
end

for j=1:5
data_TSK_15_nosnow_frac_season{j}=mean(data_TSK_15_nosnow_frac(:,:,X{j}),3,'omitnan');
data_TSK_20_nosnow_binary_season{j}=mean(data_TSK_20_nosnow_binary(:,:,X{j}),3,'omitnan');
data_TSK_nosnow_2m_frac_season{j}=mean(data_TSK_nosnow_2m_frac(:,:,X{j}),3,'omitnan');
data_TSK_5cmsnow_15_frac_season{j}=mean(data_TSK_5cmsnow_15_frac(:,:,X{j}),3,'omitnan');
end

%ERA5 and JRA55 in 2018
for i=1:length(x0)
   load(['/Volumes/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   load(['/Volumes/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestring(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   data_ME_ERA5(:,:,i)=nanmean(data_ERA5-data_satellite,3); 
 load(['/Volumes/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestring(x0(i),:),'.mat'])
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
ERA5_ME{j}=ERA5_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME{j}=JRA55_ME_season;
end

title_name={'ERA5','JRA55','ERA5-JRA55'};
figure
[ha, pos] = tight_subplot(1,3,[.01 .01],[.01 .04],[.03 .03]);
axes(ha(1));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,ERA5_ME{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
m_gshhs_l('color','k');
caxis([-20 20])
cmocean('balance',600)
colorbar
title(title_name{1},'FontSize',16)
colorbar
axes(ha(2));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,JRA55_ME{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
m_gshhs_l('color','k');
caxis([-20 20])
cmocean('balance',600)
title(title_name{2},'FontSize',16)
colorbar
axes(ha(3));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,ERA5_ME{1}-JRA55_ME{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',600)
title(title_name{3},'FontSize',16)
colorbar


title_name={'Quasi-ERA5','Quasi-JRA55','Exp-Interim','Exp-Snow'};
figure
[ha, pos] = tight_subplot(2,2,[.01 .01],[.01 .04],[.03 .03]);
axes(ha(1));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_TSK_15_nosnow_frac_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-15 15])
cmocean('balance',600)
colorbar
title(title_name{1},'FontSize',16)
colorbar
axes(ha(2));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_TSK_20_nosnow_binary_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-15 15])
cmocean('balance',600)
title(title_name{2},'FontSize',16)
colorbar
axes(ha(3));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_TSK_nosnow_2m_frac_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-15 15])
cmocean('balance',600)
title(title_name{3},'FontSize',16)
colorbar
axes(ha(4));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_TSK_5cmsnow_15_frac_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-15 15])
cmocean('balance',600)
title(title_name{4},'FontSize',16)
colorbar

%% test the normal IST in Polar WRF here

dates = datenum('02-Jan-2018'):datenum('03-Jan-2019'); % 29Nov 2023: check the correct date for 2018
datestring = datestr(dates, 'yyyymmdd');
datevect=datevec(dates);

x0=(1:length(datevect))';
[x1,]=find(datevect(:,2)==3 | datevect(:,2)==1 | datevect(:,2)==2);
[x2,]=find(datevect(:,2)==6 | datevect(:,2)==4 | datevect(:,2)==5);
[x3,]=find(datevect(:,2)==9 | datevect(:,2)==7 | datevect(:,2)==8);
[x4,]=find(datevect(:,2)==12 | datevect(:,2)==10 | datevect(:,2)==11);
X={x0,x1,x2,x3,x4};


data=ncread('/Volumes/Extreme_SSD/SIT_2018_daily/SIT_50/TSK_50_polargrid.nc','TSK');
TSK_10=permute(data,[2 1 3]);

for i=1:length(x0)
   load(['/Volumes/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   % ERA5 radiation 
   % 
   TSK_ERA5_10=TSK_10(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   TSK_ERA5_10(isnan(data_satellite))=nan;
   data_TSK_ERA5_10(:,:,i)=mean((TSK_ERA5_10-data_satellite),3,'omitnan'); 
end

for j=1:5
data_TSK_ERA5_10_season{j}=mean(data_TSK_ERA5_10(:,:,X{j}),3,'omitnan');
end


figure
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,data_TSK_ERA5_10_season{1});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-20 20])
cmocean('balance',600)
title(title_name{1},'FontSize',16)

%% calculate the ice conduction by ourself
HFX_20=permute(ncread('/Volumes/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','HFX'),[2 1 3]);
LH_20=permute(ncread('/Volumes/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LH'),[2 1 3]);
LWDNB_20=permute(ncread('/Volumes/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LWDNB'),[2 1 3]);
LWUPB_20=permute(ncread('/Volumes/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LWUPB'),[2 1 3]);
SWDNB_20=permute(ncread('/Volumes/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','SWDNB'),[2 1 3]);
SWUPB_20=permute(ncread('/Volumes/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','SWUPB'),[2 1 3]);

for i=1:361
   load(['/Volumes/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   HFX_ERA5_20=HFX_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   HFX_ERA5_20(isnan(data_satellite))=nan;
   data_HFX_ERA5_20(:,:,i)=mean((HFX_ERA5_20),3,'omitnan'); 

   LH_ERA5_20=LH_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LH_ERA5_20(isnan(data_satellite))=nan;
   data_LH_ERA5_20(:,:,i)=mean((LH_ERA5_20),3,'omitnan'); 

   LWDNB_ERA5_20=LWDNB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWDNB_ERA5_20(isnan(data_satellite))=nan;
   data_LWDNB_ERA5_20(:,:,i)=mean((LWDNB_ERA5_20),3,'omitnan'); 

   LWUPB_ERA5_20=LWUPB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWUPB_ERA5_20(isnan(data_satellite))=nan;
   data_LWUPB_ERA5_20(:,:,i)=mean((LWUPB_ERA5_20),3,'omitnan'); 

   SWDNB_ERA5_20=SWDNB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWDNB_ERA5_20(isnan(data_satellite))=nan;
   data_SWDNB_ERA5_20(:,:,i)=mean((SWDNB_ERA5_20),3,'omitnan'); 

   SWUPB_ERA5_20=SWUPB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWUPB_ERA5_20(isnan(data_satellite))=nan;
   data_SWUPB_ERA5_20(:,:,i)=mean((SWUPB_ERA5_20),3,'omitnan'); 

end

for j=1:5
data_HFX_ERA5_20_season{j}=mean(data_HFX_ERA5_20(:,:,X{j}),3,'omitnan');
data_LH_ERA5_20_season{j}=mean(data_LH_ERA5_20(:,:,X{j}),3,'omitnan');
data_LWDNB_ERA5_20_season{j}=mean(data_LWDNB_ERA5_20(:,:,X{j}),3,'omitnan');
data_LWUPB_ERA5_20_season{j}=mean(data_LWUPB_ERA5_20(:,:,X{j}),3,'omitnan');
data_SWDNB_ERA5_20_season{j}=mean(data_SWDNB_ERA5_20(:,:,X{j}),3,'omitnan');
data_SWUPB_ERA5_20_season{j}=mean(data_SWUPB_ERA5_20(:,:,X{j}),3,'omitnan');
end

R_JRA55=-(data_LWUPB_ERA5_20_season{1}+data_SWUPB_ERA5_20_season{1}-data_LWDNB_ERA5_20_season{1}-data_SWDNB_ERA5_20_season{1}+data_HFX_ERA5_20_season{1}+data_LH_ERA5_20_season{1});
R_ERA5=-(data_LWUPB_ERA5_15_season{1}+data_SWUPB_ERA5_15_season{1}-data_LWDNB_ERA5_15_season{1}-data_SWDNB_ERA5_15_season{1}+data_HFX_ERA5_15_season{1}+data_LH_ERA5_15_season{1});
R(:,:,1)=R_ERA5; R(:,:,2)=R_JRA55;

title_name={'ice heat conduction in Quasi-ERA5','ice heat conduction in Quasi-JRA55','diff (ERA5 - JRA55)'};
figure
[ha, pos] = tight_subplot(1,3,[.01 .01],[.01 .04],[.03 .03]);
for q=1:3
if q<3 
axes(ha(q));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,R(:,:,q));
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-100 100])
cmocean('balance',600)
title(title_name{q},'FontSize',16)
colorbar
end

if q==3
axes(ha(q));
m_proj('stereographic','lat',-90,'lon',0,'radius',40);
m_pcolor(lons,lats,R(:,:,2)-R(:,:,1));
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
%m_gshhs_l('color','k');
caxis([-50 50])
cmocean('balance',600)
title(title_name{q},'FontSize',16)
colorbar
end
end



%% To avoid the influence term of Tr and ice melting,
% here we only consider the pixel at ice freezing season (Aug Sep and Oct) and night
% Where downward longwave < 10 W/m^2

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
   load(['/Volumes/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5 radiation 
   % downward shortwave 
   msdwswrf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwswrf_all.nc','var35',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwswrf_ERA5=permute(msdwswrf_ERA5,[2 1 3]);
   msdwswrf_ERA5(isnan(data_satellite))=nan;
   msdwswrf_ERA5(msdwswrf_ERA5>10)=nan;
   data_msdwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5,3,'omitnan'); 
   % upward shortwave 
   msnswrf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnswrf_all.nc','var37',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnswrf_ERA5=permute(msnswrf_ERA5,[2 1 3]);
   msnswrf_ERA5(isnan(data_satellite))=nan;
   msnswrf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_msuwswrf_ERA5(:,:,i)=mean(msdwswrf_ERA5-msnswrf_ERA5,3,'omitnan'); 
   % downward longwave 
   msdwlwrf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msdwlwrf_all.nc','var36',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msdwlwrf_ERA5=permute(msdwlwrf_ERA5,[2 1 3]);
   msdwlwrf_ERA5(isnan(data_satellite))=nan;
   msdwlwrf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_msdwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5,3,'omitnan'); 
   % upward longwave 
   msnlwrf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msnlwrf_all.nc','var38',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msnlwrf_ERA5=permute(msnlwrf_ERA5,[2 1 3]);
   msnlwrf_ERA5(isnan(data_satellite))=nan;
   msnlwrf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_msuwlwrf_ERA5(:,:,i)=mean(msdwlwrf_ERA5-msnlwrf_ERA5,3,'omitnan'); 
   % sensible heat flux
   msshf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_msshf_all.nc','var33',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   msshf_ERA5=permute(msshf_ERA5,[2 1 3]);
   msshf_ERA5(isnan(data_satellite))=nan;
   msshf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_msshf_ERA5(:,:,i)=mean(-msshf_ERA5,3,'omitnan'); 
   % latent heat flux
   mslhf_ERA5=ncread('/Volumes/Extreme_SSD/ERA5_radiation_polargrid/ERA5_mslhf_all.nc','var34',[1 1 8018+24*(i-1)],[Inf Inf 24]); % add one hour here for keep consistans with MODIS
   mslhf_ERA5=permute(mslhf_ERA5,[2 1 3]);
   mslhf_ERA5(isnan(data_satellite))=nan;
   mslhf_ERA5(isnan(msdwswrf_ERA5))=nan;
   data_mslhf_ERA5(:,:,i)=mean(-mslhf_ERA5,3,'omitnan'); 

   % JRA55 radiation   
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end   
   % downward shortwave
   dswrf_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dswrf_all_polargrid.nc','DSWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dswrf_JRA55=permute(dswrf_JRA55,[2 1 3 4]);
   dswrf_JRA55=reshape(dswrf_JRA55,[332 316 8]);
   dswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   dswrf_JRA55(dswrf_JRA55>10)=nan;
   data_dswrf_JRA55(:,:,i)=mean(dswrf_JRA55,3,'omitnan');
   % upward shortwave
   uswrf_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_uswrf_all_polargrid.nc','USWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   uswrf_JRA55=permute(uswrf_JRA55,[2 1 3 4]);
   uswrf_JRA55=reshape(uswrf_JRA55,[332 316 8]);
   uswrf_JRA55(isnan(data_satellite_JRA55))=nan;
   uswrf_JRA55(isnan(dswrf_JRA55))=nan;
   data_uswrf_JRA55(:,:,i)=mean(uswrf_JRA55,3,'omitnan');
   % downward longwave 
   dlwrf_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_dlwrf_all_polargrid.nc','DLWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   dlwrf_JRA55=permute(dlwrf_JRA55,[2 1 3 4]);
   dlwrf_JRA55=reshape(dlwrf_JRA55,[332 316 8]);
   dlwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   dlwrf_JRA55(isnan(dswrf_JRA55))=nan;
   data_dlwrf_JRA55(:,:,i)=mean(dlwrf_JRA55,3,'omitnan');
   % upward longwave
   ulwrf_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_ulwrf_all_polargrid.nc','ULWRF_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   ulwrf_JRA55=permute(ulwrf_JRA55,[2 1 3 4]);
   ulwrf_JRA55=reshape(ulwrf_JRA55,[332 316 8]);
   ulwrf_JRA55(isnan(data_satellite_JRA55))=nan;
   ulwrf_JRA55(isnan(dswrf_JRA55))=nan;
   data_ulwrf_JRA55(:,:,i)=mean(ulwrf_JRA55,3,'omitnan');
   % sensible heat flux
   shtfl_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_shtfl_all_polargrid.nc','SHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
   shtfl_JRA55=permute(shtfl_JRA55,[2 1 3 4]);
   shtfl_JRA55=reshape(shtfl_JRA55,[332 316 8]);
   shtfl_JRA55(isnan(data_satellite_JRA55))=nan;
   shtfl_JRA55(isnan(dswrf_JRA55))=nan;
   data_shtfl_JRA55(:,:,i)=mean(shtfl_JRA55,3,'omitnan');
   % latent heat flux
   lhtfl_JRA55=ncread('/Volumes/Extreme_SSD/JRA55_radiation_polargrid/JRA55_lhtfl_all_polargrid.nc','LHTFL_GDS4_SFC_ave3h',[1 1 1 1337+4*(i-1)],[Inf Inf Inf 4]);
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



m_proj('stereographic','lat',-90,'lon',0,'radius',35);
m_pcolor(lons,lats,JRA55_ulwrf_season{2});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600)
colorbar
