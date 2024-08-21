% this programming used to analysis the radiation difference between ERA5
% and JRA55, also used to investigate the difference after applying the
% cloud filter from reanalyses




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
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
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




 
% 
% % ﻿ice heat conduction term
% i=2
% R_ERA5=-(ERA5_uswrf_season{i}+ERA5_ulwrf_season{i}-ERA5_dswrf_season{i}-ERA5_dlwrf_season{i}+ERA5_lhf_season{1}+ERA5_shf_season{i});
% R_JRA55=-(JRA55_uswrf_season{i}+JRA55_ulwrf_season{i}-JRA55_dswrf_season{i}-JRA55_dlwrf_season{i}+JRA55_lhf_season{i}+JRA55_shf_season{i});
% R(:,:,1)=R_ERA5; R(:,:,2)=R_JRA55;
% title_name={'ice heat conduction in ERA5','ice heat conduction in JRA55','diff (ERA5 - JRA55)'};
% figure
% [ha, pos] = tight_subplot(1,3,[.01 .01],[.01 .04],[.03 .03]);
% for q=1:3
% if q<3 
% axes(ha(q));
% m_proj('stereographic','lat',-90,'lon',0,'radius',40);
% m_pcolor(lons,lats,R(:,:,q));
% m_grid('ytick',8,'xtick',12,'xaxislocation','top');
% %m_gshhs_l('color','k');
% caxis([-100 100])
% cmocean('balance',600)
% title(title_name{q},'FontSize',16)
% colorbar
% end
% 
% if q==3
% axes(ha(q));
% m_proj('stereographic','lat',-90,'lon',0,'radius',40);
% m_pcolor(lons,lats,R(:,:,2)-R(:,:,1));
% m_grid('ytick',8,'xtick',12,'xaxislocation','top');
% %m_gshhs_l('color','k');
% caxis([-50 50])
% cmocean('balance',600)
% title(title_name{q},'FontSize',16)
% colorbar
% end
% end
% 
% 
% R_JRA55=-(data_uswrf_JRA55+data_ulwrf_JRA55-data_dswrf_JRA55-data_dlwrf_JRA55+data_lhtfl_JRA55+data_shtfl_JRA55);
% mean_R_ERA5=mean(R_JRA55,3,'omitnan');
% m_proj('stereographic','lat',-90,'lon',0,'radius',40);
% m_pcolor(lons,lats,mean_R_ERA5);
% m_grid('ytick',8,'xtick',12,'xaxislocation','top');
% %m_gshhs_l('color','k');
% caxis([-100 100])
% cmocean('balance',600)










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
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
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
save ERA5_radiation_less10w ERA5* data*ERA5 -v7.3
save JRA55_radiation_less10w JRA55* data*JRA55 -v7.3


m_proj('stereographic','lat',-90,'lon',0,'radius',35);
m_pcolor(lons,lats,JRA55_ulwrf_season{2});
m_grid('ytick',8,'xtick',12,'xaxislocation','top');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600)
colorbar
