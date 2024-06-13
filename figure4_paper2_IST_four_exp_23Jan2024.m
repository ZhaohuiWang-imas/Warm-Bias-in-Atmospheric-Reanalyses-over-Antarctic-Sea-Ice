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

data=ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/GRDFLX_nosnow_20_polargrid.nc','TSK');
TSK_20_nosnow_binary=permute(data,[2 1 3]);
data=ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/GRDFLX_nosnow_15_polargrid.nc','TSK');
TSK_15_nosnow_frac=permute(data,[2 1 3]);
data=ncread('/Volumes/ExtremePro/Extreme_SSD/GRDFLX_test/SEB_var_nosnow_2m_frac/SEB_var_nosnow_2m_frac_polargrid.nc','TSK');
TSK_nosnow_2m_frac=permute(data,[2 1 3]);
data=ncread('/Volumes/ExtremePro/Extreme_SSD/SIT_2018_daily/SIT/Temp_15_polargrid.nc','TSK');
TSK_5cmsnow_15_frac=permute(data,[2 1 3]);
%TSK_5cmsnow_15_frac=cat(3,TSK_5cmsnow_15_frac(:,:,1:(274*24)),TSK_5cmsnow_15_frac(:,:,(278*24+1):end));

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')


% IST difference between 4 experiment
for i=1:length(x0)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestring(x0(i),:),'.mat'])
   %changed to the gauss resampling method
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

%% calculate the domain-averge IST from model and reanalysis in 2018

 load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    QuasiJRA55_domainIST=sum(data_TSK_20_nosnow_binary_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_TSK_20_nosnow_binary_season{1})),'all','omitnan');
    QuasiERA5_domainIST=sum(data_TSK_15_nosnow_frac_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_TSK_15_nosnow_frac_season{1})),'all','omitnan');
    SIT_domainIST=sum(data_TSK_nosnow_2m_frac_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_TSK_nosnow_2m_frac_season{1})),'all','omitnan');
    SNOW_domainIST=sum(data_TSK_5cmsnow_15_frac_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(data_TSK_5cmsnow_15_frac_season{1})),'all','omitnan');
    
    % 3.5368 for EXP-SIT, 3.2505 for EXP-Snow,  3.9653 for QuasiERA5,  1.6750 for QuasiJRA55
    % This has been changed from previous because resampling method changed to Gauss





figure
[ha, pos] = tight_subplot(2,2,[0.01 0.02],[0.05 0.05],[.13 .13]);
title_name={'Quasi-ERA5','Quasi-JRA-55','Exp-SIT','Exp-SNOW'};
text_all={'(a)','(b)','(c)','(d)'};

axes(ha(1));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_15_nosnow_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',600);
title(title_name{1},'FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{1},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')

axes(ha(2));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_20_nosnow_binary_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',600);
title(title_name{2},'FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{2},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')

axes(ha(3));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_nosnow_2m_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',600);
title(title_name{3},'FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{3},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')

axes(ha(4));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_5cmsnow_15_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',600);
title(title_name{4},'FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{4},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')










%% 

figure
[ha, pos] = tight_subplot(2,2,[0.01 0.02],[0.05 0.05],[.13 .13]);
title_name={'Quasi-ERA5','Quasi-JRA-55','Exp-SIT','Exp-SNOW'};
text_all={'(a)','(b)','(c)','(d)'};

axes(ha(1));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_20_nosnow_binary_season{1} - data_TSK_15_nosnow_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600);
title('Quasi-JRA-55 - Quasi-ERA5','FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{1},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')

axes(ha(2));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_20_nosnow_binary_season{1} - data_TSK_nosnow_2m_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600);
title('Quasi-ERA5 - Exp-SIT','FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{2},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')



axes(ha(3));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_nosnow_2m_frac_season{1} - data_TSK_15_nosnow_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600);
title('Exp-SIT - Quasi-ERA5','FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{3},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')

axes(ha(4));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_5cmsnow_15_frac_season{1} - data_TSK_15_nosnow_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600);
title('Exp-SNOW - Quasi-ERA5','FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{4},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')







%% seasonal plot as requested by reviewer

figure
%set(gcf,'unit','normalized','position',[.1 .1 .6 .85])
season={'ALL','JFM','AMJ','JAS','OND'};
title_name={'Quasi-ERA5','Quasi-JRA-55','Exp-SIT','Exp-SNOW'};
text_no1={'(a1)','(b1)','(c1)','(d1)','(e1)'};
text_no2={'(a2)','(b2)','(c2)','(d2)','(e2)'};
text_no3={'(a3)','(b3)','(c3)','(d3)','(e3)'};
text_no4={'(a4)','(b4)','(c4)','(d4)','(e4)'};


for i=1:5
    for j=1
ax1=axes('position',[0.1+0.12*(i-1) 0.75-0.16*(j-1) .15 .15]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_20_nosnow_binary_season{i} - data_TSK_15_nosnow_frac_season{i});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600);
if j==1
title(season{i},'FontSize',16)
end
if i==1
ylabel('Q-JRA-55 - Q-ERA5','FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no1{i},'fontsize',15,'fontname','bold')
end


for i=1:5
    for j=2
ax1=axes('position',[0.1+0.12*(i-1) 0.75-0.16*(j-1) .15 .15]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_20_nosnow_binary_season{i} - data_TSK_nosnow_2m_frac_season{i});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600);
if j==1
title(season{i},'FontSize',16)
end
if i==1
ylabel('Q-ERA5 - Exp-SIT','FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no2{i},'fontsize',15,'fontname','bold')
end


for i=1:5
    for j=3
ax1=axes('position',[0.1+0.12*(i-1) 0.75-0.16*(j-1) .15 .15]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_nosnow_2m_frac_season{i} - data_TSK_15_nosnow_frac_season{i});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600);
if j==1
title(season{i},'FontSize',16)
end
if i==1
ylabel('Exp-SIT - Q-ERA5','FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no3{i},'fontsize',15,'fontname','bold')
end

for i=1:5
    for j=4
ax1=axes('position',[0.1+0.12*(i-1) 0.75-0.16*(j-1) .15 .15]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_5cmsnow_15_frac_season{i} - data_TSK_15_nosnow_frac_season{i});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-5 5])
cmocean('balance',600);
if j==1
title(season{i},'FontSize',16)
end
if i==1
ylabel('Exp-SNOW - Q-ERA5','FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no4{i},'fontsize',15,'fontname','bold')
end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
h.Label.String = 'MBias difference (K)';
set(h,'position',[.49 .13 .01 .4])


%%











%% SEB analysis - ice conduction analysis added as required by reviewer
clear dates datestring datevect
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

% EXP-SIT

HFX_SIT=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','HFX'),[2 1 3]);
LH_SIT=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','LH'),[2 1 3]);
LWDNB_SIT=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','LWDNB'),[2 1 3]);
LWUPB_SIT=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','LWUPB'),[2 1 3]);
SWDNB_SIT=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','SWDNB'),[2 1 3]);
SWUPB_SIT=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','SWUPB'),[2 1 3]);

for i=1:361
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestring(x0(i),:),'.mat'])
   %changed to gauss resampling method

   SWDNB_ERA5_SIT=SWDNB_SIT(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWDNB_ERA5_SIT(isnan(data_satellite))=nan;
   SWDNB_ERA5_SIT(SWDNB_ERA5_SIT>10)=nan;
   data_SWDNB_ERA5_SIT(:,:,i)=mean((SWDNB_ERA5_SIT),3,'omitnan'); 

   HFX_ERA5_SIT=HFX_SIT(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   HFX_ERA5_SIT(isnan(data_satellite))=nan;
   HFX_ERA5_SIT(isnan(SWDNB_ERA5_SIT))=nan;
   data_HFX_ERA5_SIT(:,:,i)=mean((HFX_ERA5_SIT),3,'omitnan'); 

   LH_ERA5_SIT=LH_SIT(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LH_ERA5_SIT(isnan(data_satellite))=nan;
   LH_ERA5_SIT(isnan(SWDNB_ERA5_SIT))=nan;
   data_LH_ERA5_SIT(:,:,i)=mean((LH_ERA5_SIT),3,'omitnan'); 

   LWDNB_ERA5_SIT=LWDNB_SIT(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWDNB_ERA5_SIT(isnan(data_satellite))=nan;
   LWDNB_ERA5_SIT(isnan(SWDNB_ERA5_SIT))=nan;
   data_LWDNB_ERA5_SIT(:,:,i)=mean((LWDNB_ERA5_SIT),3,'omitnan'); 

   LWUPB_ERA5_SIT=LWUPB_SIT(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWUPB_ERA5_SIT(isnan(data_satellite))=nan;
   LWUPB_ERA5_SIT(isnan(SWDNB_ERA5_SIT))=nan;
   data_LWUPB_ERA5_SIT(:,:,i)=mean((LWUPB_ERA5_SIT),3,'omitnan'); 

   SWUPB_ERA5_SIT=SWUPB_SIT(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWUPB_ERA5_SIT(isnan(data_satellite))=nan;
   SWUPB_ERA5_SIT(isnan(SWDNB_ERA5_SIT))=nan;
   data_SWUPB_ERA5_SIT(:,:,i)=mean((SWUPB_ERA5_SIT),3,'omitnan'); 

end

for j=1:2
data_HFX_ERA5_SIT_season{j}=mean(data_HFX_ERA5_SIT(:,:,X{j}),3,'omitnan');
data_LH_ERA5_SIT_season{j}=mean(data_LH_ERA5_SIT(:,:,X{j}),3,'omitnan');
data_LWDNB_ERA5_SIT_season{j}=mean(data_LWDNB_ERA5_SIT(:,:,X{j}),3,'omitnan');
data_LWUPB_ERA5_SIT_season{j}=mean(data_LWUPB_ERA5_SIT(:,:,X{j}),3,'omitnan');
data_SWDNB_ERA5_SIT_season{j}=mean(data_SWDNB_ERA5_SIT(:,:,X{j}),3,'omitnan');
data_SWUPB_ERA5_SIT_season{j}=mean(data_SWUPB_ERA5_SIT(:,:,X{j}),3,'omitnan');
end




%%
HFX_SNOW=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','HFX'),[2 1 3]);
LH_SNOW=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','LH'),[2 1 3]);
LWDNB_SNOW=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','LWDNB'),[2 1 3]);
LWUPB_SNOW=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','LWUPB'),[2 1 3]);
SWDNB_SNOW=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','SWDNB'),[2 1 3]);
SWUPB_SNOW=permute(ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','SWUPB'),[2 1 3]);

for i=1:361
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestring(x0(i),:),'.mat'])
   
   SWDNB_ERA5_SNOW=SWDNB_SNOW(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWDNB_ERA5_SNOW(isnan(data_satellite))=nan;
   SWDNB_ERA5_SNOW(SWDNB_ERA5_SNOW>10)=nan;
   data_SWDNB_ERA5_SNOW(:,:,i)=mean((SWDNB_ERA5_SNOW),3,'omitnan'); 
   
   HFX_ERA5_SNOW=HFX_SNOW(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   HFX_ERA5_SNOW(isnan(data_satellite))=nan;
   HFX_ERA5_SNOW(isnan(SWDNB_ERA5_SNOW))=nan;
   data_HFX_ERA5_SNOW(:,:,i)=mean((HFX_ERA5_SNOW),3,'omitnan'); 

   LH_ERA5_SNOW=LH_SNOW(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LH_ERA5_SNOW(isnan(data_satellite))=nan;
   LH_ERA5_SNOW(isnan(SWDNB_ERA5_SNOW))=nan;
   data_LH_ERA5_SNOW(:,:,i)=mean((LH_ERA5_SNOW),3,'omitnan'); 

   LWDNB_ERA5_SNOW=LWDNB_SNOW(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWDNB_ERA5_SNOW(isnan(data_satellite))=nan;
   LWDNB_ERA5_SNOW(isnan(SWDNB_ERA5_SNOW))=nan;
   data_LWDNB_ERA5_SNOW(:,:,i)=mean((LWDNB_ERA5_SNOW),3,'omitnan'); 

   LWUPB_ERA5_SNOW=LWUPB_SNOW(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   LWUPB_ERA5_SNOW(isnan(data_satellite))=nan;
   LWUPB_ERA5_SNOW(isnan(SWDNB_ERA5_SNOW))=nan;
   data_LWUPB_ERA5_SNOW(:,:,i)=mean((LWUPB_ERA5_SNOW),3,'omitnan'); 

   SWUPB_ERA5_SNOW=SWUPB_SNOW(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   SWUPB_ERA5_SNOW(isnan(data_satellite))=nan;
   SWUPB_ERA5_SNOW(isnan(SWDNB_ERA5_SNOW))=nan;
   data_SWUPB_ERA5_SNOW(:,:,i)=mean((SWUPB_ERA5_SNOW),3,'omitnan'); 

end


for j=1:2
data_HFX_ERA5_SNOW_season{j}=mean(data_HFX_ERA5_SNOW(:,:,X{j}),3,'omitnan');
data_LH_ERA5_SNOW_season{j}=mean(data_LH_ERA5_SNOW(:,:,X{j}),3,'omitnan');
data_LWDNB_ERA5_SNOW_season{j}=mean(data_LWDNB_ERA5_SNOW(:,:,X{j}),3,'omitnan');
data_LWUPB_ERA5_SNOW_season{j}=mean(data_LWUPB_ERA5_SNOW(:,:,X{j}),3,'omitnan');
data_SWDNB_ERA5_SNOW_season{j}=mean(data_SWDNB_ERA5_SNOW(:,:,X{j}),3,'omitnan');
data_SWUPB_ERA5_SNOW_season{j}=mean(data_SWUPB_ERA5_SNOW(:,:,X{j}),3,'omitnan');
end

q=2;% this should be 2 to only considering the ASO months % should double check later why made mistake
R_SIT=-(data_LWUPB_ERA5_SIT_season{q}+data_SWUPB_ERA5_SIT_season{q}-data_LWDNB_ERA5_SIT_season{q}-data_SWDNB_ERA5_SIT_season{q}+data_HFX_ERA5_SIT_season{q}+data_LH_ERA5_SIT_season{q});
R_SNOW=-(data_LWUPB_ERA5_SNOW_season{q}+data_SWUPB_ERA5_SNOW_season{q}-data_LWDNB_ERA5_SNOW_season{q}-data_SWDNB_ERA5_SNOW_season{q}+data_HFX_ERA5_SNOW_season{q}+data_LH_ERA5_SNOW_season{q});
R(:,:,1)=R_SIT; R(:,:,2)=R_SNOW;


%% calculate the domain-averge ice heat conduction from model

load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
EXPSIT_domain=sum(R_SIT.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R_SIT)),'all','omitnan');
EXPSNOW_domain=sum(R_SNOW.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R_SNOW)),'all','omitnan');
QuasiDiff_domain=sum((R(:,:,2)-R(:,:,1)).*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R(:,:,2)-R(:,:,1))),'all','omitnan');


title_name={'Ice heat conduction in Exp-SIT','Ice heat conduction in Exp-SNOW','Diff (Exp-SIT minus Exp-SNOW)'};
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
caxis([-40 40])
cmocean('balance',600)
title(title_name{q},'FontSize',18)
m_text(-43,-45,text_all{q},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','W m^-^2')
end
end



