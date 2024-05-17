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
    
    % 4.7144 for EXP-SIT, 4.4643 for EXP-Snow, 5.1173 for QuasiERA5, 2.8996 for QuasiJRA55
    % This has been changed because resampling method changed to Gauss




title_name={'Quasi-ERA5','Quasi-JRA55','Exp-SIT','Exp-SNOW'};
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

figure
[ha, pos] = tight_subplot(2,2,[0.01 0.02],[0.05 0.05],[.13 .13]);
title_name={'Quasi-ERA5','Quasi-JRA55','Exp-SIT','Exp-SNOW'};
text_all={'(a)','(b)','(c)','(d)'};

axes(ha(1));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,data_TSK_15_nosnow_frac_season{1});
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-12 12])
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
caxis([-12 12])
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
caxis([-12 12])
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
caxis([-12 12])
cmocean('balance',600);
title(title_name{4},'FontSize',18,'Interpreter','none')
m_text(-43,-45,text_all{4},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')
