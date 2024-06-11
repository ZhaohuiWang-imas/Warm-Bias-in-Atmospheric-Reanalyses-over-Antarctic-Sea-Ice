clear
%date of each experiment
dates = datenum('02-Jan-2018'):datenum('03-Jan-2019');
datestring = datestr(dates, 'yyyymmdd');
datevect=datevec(dates);

datestring=[datestring(1:274,:);datestring(279:365,:)];
datevect=[datevect(1:274,:);datevect(279:365,:)];

x0=(1:length(datevect))';
[x1,]=find(datevect(:,2)==3 | datevect(:,2)==1 | datevect(:,2)==2);
[x2,]=find(datevect(:,2)==6 | datevect(:,2)==4 | datevect(:,2)==5);
[x3,]=find(datevect(:,2)==9 | datevect(:,2)==7 | datevect(:,2)==8);
[x4,]=find(datevect(:,2)==12 | datevect(:,2)==10 | datevect(:,2)==11);
X={x0,x1,x2,x3,x4};


cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')

% below has to double check
HFX_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','HFX'),[2 1 3]);
LH_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LH'),[2 1 3]);
LWDNB_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LWDNB'),[2 1 3]);
LWUPB_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LWUPB'),[2 1 3]);
SWDNB_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','SWDNB'),[2 1 3]);
SWUPB_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','SWUPB'),[2 1 3]);

for i=1:361
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestring(x0(i),:),'.mat'])
   %changed to gauss resampling method

   SWDNB_ERA5_20=SWDNB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWDNB_ERA5_20(isnan(data_satellite))=nan;
   data_SWDNB_ERA5_20(:,:,i)=mean((SWDNB_ERA5_20),3,'omitnan'); 

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




%%
HFX_15=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_15_nosnow/SEB_15_polargrid_test.nc','HFX'),[2 1 3]);
LH_15=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_15_nosnow/SEB_15_polargrid_test.nc','LH'),[2 1 3]);
LWDNB_15=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_15_nosnow/SEB_15_polargrid_test.nc','LWDNB'),[2 1 3]);
LWUPB_15=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_15_nosnow/SEB_15_polargrid_test.nc','LWUPB'),[2 1 3]);
SWDNB_15=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_15_nosnow/SEB_15_polargrid_test.nc','SWDNB'),[2 1 3]);
SWUPB_15=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_15_nosnow/SEB_15_polargrid_test.nc','SWUPB'),[2 1 3]);

for i=1:361
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   SWDNB_ERA5_15=SWDNB_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWDNB_ERA5_15(isnan(data_satellite))=nan;
   data_SWDNB_ERA5_15(:,:,i)=mean((SWDNB_ERA5_15),3,'omitnan'); 
   
   HFX_ERA5_15=HFX_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   HFX_ERA5_15(isnan(data_satellite))=nan;
   data_HFX_ERA5_15(:,:,i)=mean((HFX_ERA5_15),3,'omitnan'); 

   LH_ERA5_15=LH_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LH_ERA5_15(isnan(data_satellite))=nan;
   data_LH_ERA5_15(:,:,i)=mean((LH_ERA5_15),3,'omitnan'); 

   LWDNB_ERA5_15=LWDNB_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWDNB_ERA5_15(isnan(data_satellite))=nan;
   data_LWDNB_ERA5_15(:,:,i)=mean((LWDNB_ERA5_15),3,'omitnan'); 

   LWUPB_ERA5_15=LWUPB_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWUPB_ERA5_15(isnan(data_satellite))=nan;
   data_LWUPB_ERA5_15(:,:,i)=mean((LWUPB_ERA5_15),3,'omitnan'); 

   SWUPB_ERA5_15=SWUPB_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWUPB_ERA5_15(isnan(data_satellite))=nan;
   data_SWUPB_ERA5_15(:,:,i)=mean((SWUPB_ERA5_15),3,'omitnan'); 

end


for j=1:5
data_HFX_ERA5_15_season{j}=mean(data_HFX_ERA5_15(:,:,X{j}),3,'omitnan');
data_LH_ERA5_15_season{j}=mean(data_LH_ERA5_15(:,:,X{j}),3,'omitnan');
data_LWDNB_ERA5_15_season{j}=mean(data_LWDNB_ERA5_15(:,:,X{j}),3,'omitnan');
data_LWUPB_ERA5_15_season{j}=mean(data_LWUPB_ERA5_15(:,:,X{j}),3,'omitnan');
data_SWDNB_ERA5_15_season{j}=mean(data_SWDNB_ERA5_15(:,:,X{j}),3,'omitnan');
data_SWUPB_ERA5_15_season{j}=mean(data_SWUPB_ERA5_15(:,:,X{j}),3,'omitnan');
end




    for i=1:5
    load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    data_HFX_ERA5_15_season_domain{i}=sum(data_HFX_ERA5_15_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_HFX_ERA5_15_season{i})),'all','omitnan');
    data_LH_ERA5_15_season_domain{i}=sum(data_LH_ERA5_15_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_LH_ERA5_15_season{i})),'all','omitnan');
    data_LWDNB_ERA5_15_season_domain{i}=sum(data_LWDNB_ERA5_15_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_LWDNB_ERA5_15_season{i})),'all','omitnan');
    data_LWUPB_ERA5_15_season_domain{i}=sum(data_LWUPB_ERA5_15_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_LWUPB_ERA5_15_season{i})),'all','omitnan');
    data_SWDNB_ERA5_15_season_domain{i}=sum(data_SWDNB_ERA5_15_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_SWDNB_ERA5_15_season{i})),'all','omitnan');
    data_SWUPB_ERA5_15_season_domain{i}=sum(data_SWUPB_ERA5_15_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_SWUPB_ERA5_15_season{i})),'all','omitnan');

    data_HFX_ERA5_20_season_domain{i}=sum(data_HFX_ERA5_20_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_HFX_ERA5_20_season{i})),'all','omitnan');
    data_LH_ERA5_20_season_domain{i}=sum(data_LH_ERA5_20_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_LH_ERA5_20_season{i})),'all','omitnan');
    data_LWDNB_ERA5_20_season_domain{i}=sum(data_LWDNB_ERA5_20_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_LWDNB_ERA5_20_season{i})),'all','omitnan');
    data_LWUPB_ERA5_20_season_domain{i}=sum(data_LWUPB_ERA5_20_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_LWUPB_ERA5_20_season{i})),'all','omitnan');
    data_SWDNB_ERA5_20_season_domain{i}=sum(data_SWDNB_ERA5_20_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_SWDNB_ERA5_20_season{i})),'all','omitnan');
    data_SWUPB_ERA5_20_season_domain{i}=sum(data_SWUPB_ERA5_20_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_SWUPB_ERA5_20_season{i})),'all','omitnan');
    end
    





ax3=axes('position',[0.1+0.16+0.24 0.1 .33 .60]); % [left bottom width height]

figure
i=4;
Y=[data_LWDNB_ERA5_15_season_domain{i},data_LWDNB_ERA5_20_season_domain{i},data_LWDNB_ERA5_15_season_domain{i}-data_LWDNB_ERA5_20_season_domain{i};
-data_LWUPB_ERA5_15_season_domain{i},-data_LWUPB_ERA5_20_season_domain{i},-data_LWUPB_ERA5_15_season_domain{i}+data_LWUPB_ERA5_20_season_domain{i};       
-data_LH_ERA5_15_season_domain{i},-data_LH_ERA5_20_season_domain{i},-data_LH_ERA5_15_season_domain{i}+data_LH_ERA5_20_season_domain{i};
-data_HFX_ERA5_15_season_domain{i},-data_HFX_ERA5_20_season_domain{i},-data_HFX_ERA5_15_season_domain{i}+data_HFX_ERA5_20_season_domain{i};
data_SWDNB_ERA5_15_season_domain{i},data_SWDNB_ERA5_20_season_domain{i},data_SWDNB_ERA5_15_season_domain{i}-data_SWDNB_ERA5_20_season_domain{i};
-data_SWUPB_ERA5_15_season_domain{i},-data_SWUPB_ERA5_20_season_domain{i},-data_SWUPB_ERA5_15_season_domain{i}+data_SWUPB_ERA5_20_season_domain{i};];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   %yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   %yticklabels({'L_d','S_d','F_{lh}','F_{hs}','L_u','S_u'} )
   % 设置 y 轴刻度标签
   yticks = {'L_d','L_u','F_{lh}','F_{sh}','S_d','S_u'};
   set(gca, 'YTickLabel', yticks, 'FontAngle', 'italic');
   
   xlim([-300 300]);
   xlabel('Surface energy budget (W m^-^2)')
   legend('Quasi-ERA5','Quasi-JRA55 ','Quasi-ERA5 - Quasi-JRA55');
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
    %text(0.1, 0.8, '（f）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 18);

