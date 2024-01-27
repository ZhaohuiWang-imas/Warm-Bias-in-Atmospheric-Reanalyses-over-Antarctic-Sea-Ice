
dates = [datenum('02-Jan-2018'):datenum('03-Jan-2019')];
datestring = datestr(dates, 'yyyymmdd');
datevect=datevec(dates);

datestring=[datestring(1:274,:);datestring(279:365,:)];
datevect=[datevect(1:274,:);datevect(279:365,:)];


x0=(1:length(datevect))';
[x1,]=find(datevect(:,2)==8 | datevect(:,2)==9 | datevect(:,2)==10);
X={x0,x1};

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')

% this is the figure for Figure 3 

% below has to double check
HFX_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','HFX'),[2 1 3]);
LH_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LH'),[2 1 3]);
LWDNB_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LWDNB'),[2 1 3]);
LWUPB_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','LWUPB'),[2 1 3]);
SWDNB_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','SWDNB'),[2 1 3]);
SWUPB_20=permute(ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/WRF_SIT_20_nosnow/SEB_20_polargrid_test.nc','SWUPB'),[2 1 3]);

for i=1:361
   load(['/Volumes/ExtremePro/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   SWDNB_ERA5_20=SWDNB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWDNB_ERA5_20(isnan(data_satellite))=nan;
   SWDNB_ERA5_20(SWDNB_ERA5_20>10)=nan;
   data_SWDNB_ERA5_20(:,:,i)=mean((SWDNB_ERA5_20),3,'omitnan'); 

   HFX_ERA5_20=HFX_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   HFX_ERA5_20(isnan(data_satellite))=nan;
   HFX_ERA5_20(isnan(SWDNB_ERA5_20))=nan;
   data_HFX_ERA5_20(:,:,i)=mean((HFX_ERA5_20),3,'omitnan'); 

   LH_ERA5_20=LH_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LH_ERA5_20(isnan(data_satellite))=nan;
   LH_ERA5_20(isnan(SWDNB_ERA5_20))=nan;
   data_LH_ERA5_20(:,:,i)=mean((LH_ERA5_20),3,'omitnan'); 

   LWDNB_ERA5_20=LWDNB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWDNB_ERA5_20(isnan(data_satellite))=nan;
   LWDNB_ERA5_20(isnan(SWDNB_ERA5_20))=nan;
   data_LWDNB_ERA5_20(:,:,i)=mean((LWDNB_ERA5_20),3,'omitnan'); 

   LWUPB_ERA5_20=LWUPB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWUPB_ERA5_20(isnan(data_satellite))=nan;
   LWUPB_ERA5_20(isnan(SWDNB_ERA5_20))=nan;
   data_LWUPB_ERA5_20(:,:,i)=mean((LWUPB_ERA5_20),3,'omitnan'); 

   SWUPB_ERA5_20=SWUPB_20(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWUPB_ERA5_20(isnan(data_satellite))=nan;
   SWUPB_ERA5_20(isnan(SWDNB_ERA5_20))=nan;
   data_SWUPB_ERA5_20(:,:,i)=mean((SWUPB_ERA5_20),3,'omitnan'); 

end

for j=1:2
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
   load(['/Volumes/ExtremePro/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   SWDNB_ERA5_15=SWDNB_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWDNB_ERA5_15(isnan(data_satellite))=nan;
   SWDNB_ERA5_15(SWDNB_ERA5_15>10)=nan;
   data_SWDNB_ERA5_15(:,:,i)=mean((SWDNB_ERA5_15),3,'omitnan'); 
   
   HFX_ERA5_15=HFX_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   HFX_ERA5_15(isnan(data_satellite))=nan;
   HFX_ERA5_15(isnan(SWDNB_ERA5_15))=nan;
   data_HFX_ERA5_15(:,:,i)=mean((HFX_ERA5_15),3,'omitnan'); 

   LH_ERA5_15=LH_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LH_ERA5_15(isnan(data_satellite))=nan;
   LH_ERA5_15(isnan(SWDNB_ERA5_15))=nan;
   data_LH_ERA5_15(:,:,i)=mean((LH_ERA5_15),3,'omitnan'); 

   LWDNB_ERA5_15=LWDNB_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWDNB_ERA5_15(isnan(data_satellite))=nan;
   LWDNB_ERA5_15(isnan(SWDNB_ERA5_15))=nan;
   data_LWDNB_ERA5_15(:,:,i)=mean((LWDNB_ERA5_15),3,'omitnan'); 

   LWUPB_ERA5_15=LWUPB_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWUPB_ERA5_15(isnan(data_satellite))=nan;
   LWUPB_ERA5_15(isnan(SWDNB_ERA5_15))=nan;
   data_LWUPB_ERA5_15(:,:,i)=mean((LWUPB_ERA5_15),3,'omitnan'); 

   SWUPB_ERA5_15=SWUPB_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWUPB_ERA5_15(isnan(data_satellite))=nan;
   SWUPB_ERA5_15(isnan(SWDNB_ERA5_15))=nan;
   data_SWUPB_ERA5_15(:,:,i)=mean((SWUPB_ERA5_15),3,'omitnan'); 

end


for j=1:2
data_HFX_ERA5_15_season{j}=mean(data_HFX_ERA5_15(:,:,X{j}),3,'omitnan');
data_LH_ERA5_15_season{j}=mean(data_LH_ERA5_15(:,:,X{j}),3,'omitnan');
data_LWDNB_ERA5_15_season{j}=mean(data_LWDNB_ERA5_15(:,:,X{j}),3,'omitnan');
data_LWUPB_ERA5_15_season{j}=mean(data_LWUPB_ERA5_15(:,:,X{j}),3,'omitnan');
data_SWDNB_ERA5_15_season{j}=mean(data_SWDNB_ERA5_15(:,:,X{j}),3,'omitnan');
data_SWUPB_ERA5_15_season{j}=mean(data_SWUPB_ERA5_15(:,:,X{j}),3,'omitnan');
end

q=1;
R_JRA55=-(data_LWUPB_ERA5_20_season{q}+data_SWUPB_ERA5_20_season{q}-data_LWDNB_ERA5_20_season{q}-data_SWDNB_ERA5_20_season{q}+data_HFX_ERA5_20_season{q}+data_LH_ERA5_20_season{q});
R_ERA5=-(data_LWUPB_ERA5_15_season{q}+data_SWUPB_ERA5_15_season{q}-data_LWDNB_ERA5_15_season{q}-data_SWDNB_ERA5_15_season{q}+data_HFX_ERA5_15_season{q}+data_LH_ERA5_15_season{q});
R(:,:,1)=R_ERA5; R(:,:,2)=R_JRA55;

clear HFX_15 HFX_20 LH_15 LH_20 LWDNB_15 LWDNB_20 LWUPB_15 LWUPB_20 SWDNB_15 SWDNB_20 SWUPB_15 SWUPB_20
 
%% calculate the domain-averge ice heat conduction from model

 load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    QuasiJRA55_domain=sum(R_JRA55.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R_JRA55)),'all','omitnan');
    QuasiERA5_domain=sum(R_ERA5.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R_ERA5)),'all','omitnan');
    QuasiDiff_domain=sum((R(:,:,2)-R(:,:,1)).*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R(:,:,2)-R(:,:,1))),'all','omitnan');

    % 33.5190 for JRA55, 47.6473 for ERA5, 14.1283 for diff

%%

title_name={'Ice heat conduction in Quasi-ERA5','Ice heat conduction in Quasi-JRA55','Diff (Quasi-ERA5 minus Quasi-JRA55)'};
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

%% then plot the last two figures like Figure 3.13 in thesis
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

data=ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/GRDFLX_nosnow_20_polargrid.nc','TSK');
TSK_20_nosnow_binary=permute(data,[2 1 3]);
data=ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/GRDFLX_nosnow_15_polargrid.nc','TSK');
TSK_15_nosnow_frac=permute(data,[2 1 3]);
data=ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/SEB_var_nosnow_2m_frac/SEB_var_nosnow_2m_frac_polargrid.nc','TSK');
TSK_nosnow_2m_frac=permute(data,[2 1 3]);
data=ncread('/Volumes/ExtremePro/Extreme_SSD/SIT_2018_daily/SIT/Temp_15_polargrid.nc','TSK');
TSK_5cmsnow_15_frac=permute(data,[2 1 3]);
%TSK_5cmsnow_15_frac=cat(3,TSK_5cmsnow_15_frac(:,:,1:(274*24)),TSK_5cmsnow_15_frac(:,:,(278*24+1):end)); % this maybe wrong; back to check 23Nov 2023

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')


for i=1:length(x0)
   load(['/Volumes/ExtremePro/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
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

%ERA5 and JRA55 in 2018
for i=1:length(x0)
   load(['/Volumes/ExtremePro/WANG_SSD/modified_IST_satellite_clearsky/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestring(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   data_ME_ERA5(:,:,i)=mean(data_ERA5-data_satellite,3,'omitnan'); 
 load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestring(x0(i),:),'.mat'])
   data_JRA55=permute(JRA55_skt,[3 4 2 1]);
   data_JRA55=reshape(data_JRA55,[332,316,8]);
   data_JRA55(data_JRA55==0)=nan;
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   data_ME_JRA55(:,:,i)=mean(data_JRA55-data_satellite_JRA55,3,'omitnan'); 
end

for j=1:5
ERA5_ME_season=mean(data_ME_ERA5(:,:,X{j}),3,'omitnan');
ERA5_ME{j}=ERA5_ME_season;
JRA55_ME_season=mean(data_ME_JRA55(:,:,X{j}),3,'omitnan');
JRA55_ME{j}=JRA55_ME_season;
end

%% calculate the domain-averge IST from model and reanalysis in 2018

 load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    QuasiJRA55_domainIST=sum(data_TSK_20_nosnow_binary_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_TSK_20_nosnow_binary_season{1})),'all','omitnan');
    QuasiERA5_domainIST=sum(data_TSK_15_nosnow_frac_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_TSK_15_nosnow_frac_season{1})),'all','omitnan');
    JRA55_domainIST=sum(JRA55_ME{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ME{1})),'all','omitnan');
    ERA5_domainIST=sum(ERA5_ME{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ME{1})),'all','omitnan');
    
    % 0.8099 for JRA55, 5.9464 for ERA5, 5.1173 for QuasiERA5, 2.8996 for QuasiJRA55

%%


text_all={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)','(i)'};
title_name={'Quasi-ERA5','Quasi-JRA55','Quasi-ERA5 minus Quasi-JRA55','ERA5','JRA55','ERA5 minus JRA55'};
figure
[ha, pos] = tight_subplot(3,3,[.01 .015],[.0 .04],[.03 .03]);
axes(ha(4));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_15_nosnow_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-15 15])
cmocean('balance',600)
title(title_name{1},'FontSize',18)
m_text(-43,-45,text_all{4},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')

axes(ha(5));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_20_nosnow_binary_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-15 15])
cmocean('balance',600)
title(title_name{2},'FontSize',18)
m_text(-43,-45,text_all{5},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')


axes(ha(6));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_15_nosnow_frac_season{1}-data_TSK_20_nosnow_binary_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600)
title(title_name{3},'FontSize',18)
m_text(-43,-45,text_all{6},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1,'YTick',-5:2.5:5)
titleObj = get(h, 'Title');
set(titleObj, 'string', 'Bias (K)');
set(titleObj, 'HorizontalAlignment', 'left');


axes(ha(1));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,ERA5_ME{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-20 20])
cmocean('balance',600)
title(title_name{4},'FontSize',18)
m_text(-43,-45,text_all{1},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')


axes(ha(2));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,JRA55_ME{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-20 20])
cmocean('balance',600)
title(title_name{5},'FontSize',18)
m_text(-43,-45,text_all{2},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')

axes(ha(3));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,ERA5_ME{1}-JRA55_ME{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',600)
title(title_name{6},'FontSize',18)
m_text(-43,-45,text_all{3},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1)
titleObj = get(h, 'Title');
set(titleObj, 'string', 'Bias (K)');
set(titleObj, 'HorizontalAlignment', 'left');



title_name={'Ice conduction in Quasi-ERA5','Ice conduction in Quasi-JRA55','Quasi-ERA5 minus Quasi-JRA55'};
axes(ha(7));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,R(:,:,1));
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-100 100])
cmocean('balance',600)
title(title_name{1},'FontSize',18)
m_text(-43,-45,text_all{7},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1)
titleObj = get(h, 'Title');
set(titleObj, 'string', 'W/m^2');
set(titleObj, 'HorizontalAlignment', 'left');

axes(ha(8));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,R(:,:,2));
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-100 100])
cmocean('balance',600)
title(title_name{2},'FontSize',18)
m_text(-43,-45,text_all{8},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1)
titleObj = get(h, 'Title');
set(titleObj, 'string', 'W/m^2');
set(titleObj, 'HorizontalAlignment', 'left');

axes(ha(9));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,R(:,:,2)-R(:,:,1));
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-50 50])
cmocean('balance',600)
title(title_name{3},'FontSize',18)
m_text(-43,-45,text_all{9},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',16,'tickdir','out','linewidth',1)
titleObj = get(h, 'Title');
set(titleObj, 'string', 'W/m^2');
set(titleObj, 'HorizontalAlignment', 'left');
