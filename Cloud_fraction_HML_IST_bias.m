% This script used to investigate the inlfuence of low/medium/high cloud
% fraction on the surface IST bias and probably heat budget


%% Replace high/low/medium cloud fraction with total cloud fraction we used before

% here we use 01-12-2013 to 30-11-2022 because JRA-3q has bug before this
% time period
clear
%date of each experiment
dates = [datenum('01-Dec-2013'):datenum('30-Nov-2020')];
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


%% High cloud fraction

for i=1:length(x0)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestr(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   % add cloud mask here
   cloud_ERA5=ncread('/Volumes/PostDoc_drive/ERA5_cloud_LHM/ERA5_HCF_polargrid.nc','HCC',[1 1 96433+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   data_ERA5(cloud_ERA5>0.2)=nan;
   data_ME_ERA5(:,:,i)=mean(data_ERA5-data_satellite,3,'omitnan'); 
   
   % JRA3Q
    load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
    JRA3Q_LWD_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWD_polargrid.nc','dlwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_LWU_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWU_polargrid.nc','ulwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_skt=nthroot((JRA3Q_LWU_per_day-(1-0.99).*JRA3Q_LWD_per_day)./(0.99.*5.67.*(10^(-8))),4);
    JRA3Q_skt(JRA3Q_skt==0)=nan;
    % add cloud mask here
    cloud_JRA3Q=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_HCF_polargrid.nc','hcdc-hcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_skt(cloud_JRA3Q>20)=nan;
    data_JRA3Q=permute(JRA3Q_skt,[2 1 3]);
    data_ME_JRA3Q(:,:,i)=mean(data_JRA3Q-data_satellite,3,'omitnan'); 

   % JRA55
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestr(x0(i),:),'.mat'])
   data_JRA55=permute(JRA55_skt,[3 4 2 1]);
   data_JRA55=reshape(data_JRA55,[332,316,8]);
   data_JRA55(data_JRA55==0)=nan;
   % add cloud mask here
   cloud_JRA55=ncread('/Volumes/PostDoc_drive/JRA55_cloud_LHM_merge/JRA55_HCF_merge_polargrid.nc','HCDC_GDS4_ISBY',[1 1 32145+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   data_JRA55(cloud_JRA55>20)=nan;
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   data_ME_JRA55(:,:,i)=mean(data_JRA55-data_satellite_JRA55,3,'omitnan'); 
   i
end

cd /Volumes/ExtremePro/MODIS_gauss
save data_ME_02cloud_HCF_gauss17km.mat data_ME* -v7.3


%% Medium cloud fraction

for i=1:length(x0)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestr(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   % add cloud mask here
   cloud_ERA5=ncread('/Volumes/PostDoc_drive/ERA5_cloud_LHM/ERA5_MCF_polargrid.nc','MCC',[1 1 96433+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   data_ERA5(cloud_ERA5>0.2)=nan;
   data_ME_ERA5(:,:,i)=mean(data_ERA5-data_satellite,3,'omitnan'); 

   % JRA3Q
    load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
    JRA3Q_LWD_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWD_polargrid.nc','dlwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_LWU_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWU_polargrid.nc','ulwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_skt=nthroot((JRA3Q_LWU_per_day-(1-0.99).*JRA3Q_LWD_per_day)./(0.99.*5.67.*(10^(-8))),4);
    JRA3Q_skt(JRA3Q_skt==0)=nan;
    % add cloud mask here
    cloud_JRA3Q=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_MCF_polargrid.nc','mcdc-mcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_skt(cloud_JRA3Q>20)=nan;
    data_JRA3Q=permute(JRA3Q_skt,[2 1 3]);
    data_ME_JRA3Q(:,:,i)=mean(data_JRA3Q-data_satellite,3,'omitnan'); 

   % JRA55
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestr(x0(i),:),'.mat'])
   data_JRA55=permute(JRA55_skt,[3 4 2 1]);
   data_JRA55=reshape(data_JRA55,[332,316,8]);
   data_JRA55(data_JRA55==0)=nan;
   % add cloud mask here
   cloud_JRA55=ncread('/Volumes/PostDoc_drive/JRA55_cloud_LHM_merge/JRA55_MCF_merge_polargrid.nc','MCDC_GDS4_ISBY',[1 1 32145+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   data_JRA55(cloud_JRA55>20)=nan;
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   data_ME_JRA55(:,:,i)=mean(data_JRA55-data_satellite_JRA55,3,'omitnan'); 
   i
end

cd /Volumes/ExtremePro/MODIS_gauss
save data_ME_02cloud_MCF_gauss17km.mat data_ME* -v7.3


%% Low cloud fraction

for i=1:length(x0)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestr(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   % add cloud mask here
   cloud_ERA5=ncread('/Volumes/PostDoc_drive/ERA5_cloud_LHM/ERA5_LCF_polargrid.nc','LCC',[1 1 96433+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   data_ERA5(cloud_ERA5>0.2)=nan;
   data_ME_ERA5(:,:,i)=mean(data_ERA5-data_satellite,3,'omitnan'); 

   % JRA3Q
    load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
    JRA3Q_LWD_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWD_polargrid.nc','dlwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_LWU_per_day=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LWU_polargrid.nc','ulwrf1have-sfc-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_skt=nthroot((JRA3Q_LWU_per_day-(1-0.99).*JRA3Q_LWD_per_day)./(0.99.*5.67.*(10^(-8))),4);
    JRA3Q_skt(JRA3Q_skt==0)=nan;
    % add cloud mask here
    cloud_JRA3Q=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LCF_polargrid.nc','lcdc-lcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
    JRA3Q_skt(cloud_JRA3Q>20)=nan;
    data_JRA3Q=permute(JRA3Q_skt,[2 1 3]);
    data_ME_JRA3Q(:,:,i)=mean(data_JRA3Q-data_satellite,3,'omitnan'); 

   % JRA55
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestr(x0(i),:),'.mat'])
   data_JRA55=permute(JRA55_skt,[3 4 2 1]);
   data_JRA55=reshape(data_JRA55,[332,316,8]);
   data_JRA55(data_JRA55==0)=nan;
   % add cloud mask here
   cloud_JRA55=ncread('/Volumes/PostDoc_drive/JRA55_cloud_LHM_merge/JRA55_LCF_merge_polargrid.nc','LCDC_GDS4_ISBY',[1 1 32145+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   data_JRA55(cloud_JRA55>20)=nan;
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   data_ME_JRA55(:,:,i)=mean(data_JRA55-data_satellite_JRA55,3,'omitnan'); 
   i
end


cd /Volumes/ExtremePro/MODIS_gauss/
save data_ME_02cloud_LCF_gauss17km.mat data_ME* -v7.3

% j=1;
% for j=1:5
% ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
% ERA5_ME{j}=ERA5_ME_season;
% JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
% JRA3Q_ME{j}=JRA3Q_ME_season;
% JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
% JRA55_ME{j}=JRA55_ME_season;
% end
% 
% load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
% area_nasa=area_nasa';
% load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
% load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')
% 
% text_no1={'(a)','(b)','(c)','(d)','(e)'};
% text_no2={'(f)','(g)','(h)','(i)','(j)'};
% text_no3={'(k)','(l)','(m)','(n)','(o)'};
% 
% figure
% set(gcf,'unit','normalized','position',[0.0 0.0 1.0 .60]) % [left bottom width height]
% data_name={'ERA5','JRA3Q',  'JRA55'};
% data_name_title={'ERA5','JRA-3Q', 'JRA-55'};
% season={'ALL','JFM','AMJ','JAS','OND'};
% for i=1:3
%     for j=1
% ax1=axes('position',[0.15*(i-1) 0.50 .37 .37]); % [left bottom width height]
% m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
% m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
% caxis([-15 15])
% cmocean('balance',30)
% m_gshhs_l('color','k');
% m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
% if j==1
% title(data_name_title{i},'FontSize',20)
% end
% if i==1
% ylabel('Bias under HCF mask','FontSize',22,'FontWeight','bold')
% end
% 
%     end
% m_text(-45,-45,text_no1{i},'fontsize',28,'fontname','bold')
% end 

  
% plot ERA5/JRA3Q/JRA55 each a line seperately

%LCF
cd /Volumes/ExtremePro/MODIS_gauss/
load data_ME_02cloud_LCF_gauss17km.mat data_ME* 
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME_LCF{j}=ERA5_ME_season;
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_LCF{j}=JRA3Q_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME_LCF{j}=JRA55_ME_season;
end

%MCF
cd /Volumes/ExtremePro/MODIS_gauss/
load data_ME_02cloud_MCF_gauss17km.mat data_ME* 
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME_MCF{j}=ERA5_ME_season;
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_MCF{j}=JRA3Q_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME_MCF{j}=JRA55_ME_season;
end

%HCF
cd /Volumes/ExtremePro/MODIS_gauss/
load data_ME_02cloud_HCF_gauss17km.mat data_ME* 
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME_HCF{j}=ERA5_ME_season;
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_HCF{j}=JRA3Q_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME_HCF{j}=JRA55_ME_season;
end

%TCF
cd /Volumes/ExtremePro/MODIS_gauss
load data_ME_02cloud_gauss17km.mat data_ME* 

clear dates datestr datevec
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);
x0=(1:length(datevec(4019:end,:)))';
[x1,]=find(datevec(4019:end,2)==3 | datevec(4019:end,2)==1 | datevec(4019:end,2)==2);
[x2,]=find(datevec(4019:end,2)==6 | datevec(4019:end,2)==4 | datevec(4019:end,2)==5);
[x3,]=find(datevec(4019:end,2)==9 | datevec(4019:end,2)==7 | datevec(4019:end,2)==8);
[x4,]=find(datevec(4019:end,2)==12 | datevec(4019:end,2)==10 | datevec(4019:end,2)==11);
X={x0,x1,x2,x3,x4};
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,4018+X{j}),3);
ERA5_ME_TCF{j}=ERA5_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,4018+X{j}),3);
JRA55_ME_TCF{j}=JRA55_ME_season;
end
clear dates datestr datevec


dates = [datenum('01-Dec-2013'):datenum('30-Nov-2020')];
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
cd /Volumes/ExtremePro/MODIS_gauss
load data_ME_02cloud_gauss17km_JRA3Q.mat
for j=1:5
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_TCF{j}=JRA3Q_ME_season;
end

%No cloud fraction mask
cd /Volumes/ExtremePro/MODIS_gauss
load data_ME_gauss17km.mat data_ME* 

clear dates datestr datevec
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);
x0=(1:length(datevec(4019:end,:)))';
[x1,]=find(datevec(4019:end,2)==3 | datevec(4019:end,2)==1 | datevec(4019:end,2)==2);
[x2,]=find(datevec(4019:end,2)==6 | datevec(4019:end,2)==4 | datevec(4019:end,2)==5);
[x3,]=find(datevec(4019:end,2)==9 | datevec(4019:end,2)==7 | datevec(4019:end,2)==8);
[x4,]=find(datevec(4019:end,2)==12 | datevec(4019:end,2)==10 | datevec(4019:end,2)==11);
X={x0,x1,x2,x3,x4};
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,4018+X{j}),3);
ERA5_ME_NCF{j}=ERA5_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,4018+X{j}),3);
JRA55_ME_NCF{j}=JRA55_ME_season;
end
clear dates datestr datevec


dates = [datenum('01-Dec-2013'):datenum('30-Nov-2020')];
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
cd /Volumes/ExtremePro/MODIS_gauss
load data_ME_gauss17km_JRA3Q.mat
for j=1:5
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_NCF{j}=JRA3Q_ME_season;
end



load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')


Var_name={'NCF','HCF','MCF','LCF','TCF'};
data_name={'No CF','HCF','MCF','LCF','TCF'};
% data_name={'hourly'};
text_no1={'(a)','(b)','(c)','(d)','(e)'};
text_no2={'(f)','(g)','(h)','(i)','(j)'};
text_no3={'(k)','(l)','(m)','(n)','(o)'};

figure
set(gcf,'unit','normalized','position',[.1 .08 .6 .85])
for i=1:5
    for j=1
ax1=axes('position',[0.1+0.16*(i-1) 0.7 .15 .20]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-88,'longitude',0,'radius',49,'rectbox','on');
m_pcolor(lons,lats,eval(['ERA5_ME_',Var_name{i},'{j}']));
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if i==1
    ylabel('ERA5','FontSize',20)
end
title(data_name{i},'FontSize',20)
    end
m_text(-45,-45,text_no1{i},'fontsize',25,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
h.Label.String = '\circC';
set(h,'position',[.90 .71 .01 .18])


for i=1:5
    for j=1
ax2=axes('position',[0.1+0.16*(i-1) 0.5 .15 .20]); % [left bottom width height]
m_pcolor(lons,lats,eval(['JRA3Q_ME_',Var_name{i},'{j}']));
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if i==1
    ylabel('JRA-3Q','FontSize',20)
end
    end
m_text(-45,-45,text_no2{i},'fontsize',25,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
h.Label.String = '\circC';
set(h,'position',[.90 .51 .01 .18])

for i=1:5
    for j=1
ax3=axes('position',[0.1+0.16*(i-1) 0.3 .15 .20]); % [left bottom width height]
m_pcolor(lons,lats,eval(['JRA55_ME_',Var_name{i},'{j}']));
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if i==1
    ylabel('JRA-55','FontSize',20)
end
    end
m_text(-45,-45,text_no3{i},'fontsize',25,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
h.Label.String = '\circC';
set(h,'position',[.90 .31 .01 .18])

%% now check the annual mean cloud fraction under difference cloud level in each reanalyses


%% now check when cloud fraction in different level when MODIS recognised it as clear sky

clear
%date of each experiment
dates = [datenum('01-Dec-2013'):datenum('30-Nov-2020')];
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


cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools
load('lon25.mat')
load('lat25.mat')


%% JRA55 cloud fraction when MODIS clear sky

for i=1:length(x0)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   % JRA55
   % add total cloud mask here
   cloud_JRA55=ncread('/Volumes/ExtremePro/WANG_SSD/JRA55_cloud/JRA55_cloud_merge_polargrid.nc','TCDC_GDS4_ISBY',[1 1 34817+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   cloud_JRA55(isnan(data_satellite_JRA55))=nan;
   data_cloud_JRA55_TCF_masked(:,:,i)=mean(cloud_JRA55,3,'omitnan'); 

   % add LCF mask here
   % JRA55
   % add LCF cloud mask here
   cloud_JRA55=ncread('/Volumes/PostDoc_drive/JRA55_cloud_LHM_merge/JRA55_LCF_merge_polargrid.nc','LCDC_GDS4_ISBY',[1 1 32145+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   cloud_JRA55(isnan(data_satellite_JRA55))=nan;
   data_cloud_JRA55_LCF_masked(:,:,i)=mean(cloud_JRA55,3,'omitnan'); 

   % add MCF mask here
   % JRA55
   % add MCF cloud mask here
   cloud_JRA55=ncread('/Volumes/PostDoc_drive/JRA55_cloud_LHM_merge/JRA55_MCF_merge_polargrid.nc','MCDC_GDS4_ISBY',[1 1 32145+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   cloud_JRA55(isnan(data_satellite_JRA55))=nan;
   data_cloud_JRA55_MCF_masked(:,:,i)=mean(cloud_JRA55,3,'omitnan'); 

   % add HCF mask here
   % JRA55
   % add HCF cloud mask here
   cloud_JRA55=ncread('/Volumes/PostDoc_drive/JRA55_cloud_LHM_merge/JRA55_HCF_merge_polargrid.nc','HCDC_GDS4_ISBY',[1 1 32145+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   cloud_JRA55(isnan(data_satellite_JRA55))=nan;
   data_cloud_JRA55_HCF_masked(:,:,i)=mean(cloud_JRA55,3,'omitnan'); 


   i
end


for j=1:5
JRA55_TCF_mask=mean(data_cloud_JRA55_TCF_masked(:,:,X{j}),3,'omitnan');
cloud_JRA55_TCF_masked{j}=JRA55_TCF_mask./100;
JRA55_HCF_mask=mean(data_cloud_JRA55_HCF_masked(:,:,X{j}),3,'omitnan');
cloud_JRA55_HCF_masked{j}=JRA55_HCF_mask./100;
JRA55_MCF_mask=mean(data_cloud_JRA55_MCF_masked(:,:,X{j}),3,'omitnan');
cloud_JRA55_MCF_masked{j}=JRA55_MCF_mask./100;
JRA55_LCF_mask=mean(data_cloud_JRA55_LCF_masked(:,:,X{j}),3,'omitnan');
cloud_JRA55_LCF_masked{j}=JRA55_LCF_mask./100;
end

%save cloud_fra_clear_sky_JRA55_HML cloud_JRA55_*_masked
cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
load cloud_fra_clear_sky_JRA55_HML cloud_JRA55_*_masked

figure
%title_name={'May', 'Jun','Jul','Aug','Sep','Oct'};
data_name={'TCF','LCF','MCF','HCF'};
[ha, pos] = tight_subplot(1,4,[0 0],[.1 .1],[.1 .1]);
var={'TCF','LCF','MCF','HCF'};
q=1;
for j=1:4
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
        m_contourf(lons,lats,eval(['cloud_JRA55_',var{j},'_masked{1}']), 0:0.05:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        m_gshhs_l('color','k');
        caxis([0 1])
        colortable =textread('WhBlGrYeRe.txt');
        colormap(colortable(1:5:end,:));
        q=q+1;
        
         title(data_name{j},'FontSize',16,'Interpreter','none')
        
%         if j==1
%          ylabel(data_name{1},'FontSize',16,'fontweight','bold')
%         end
        %m_text(-43,-45,text_all{1}{j},'fontsize',18,'fontname','bold')
end


h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Cloud fraction';
set(h,'position',[.925 .25 .01 .5])



%% ERA5 cloud fraction when MODIS clear sky

for i=1:length(x0)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   % add total cloud mask here
   cloud_ERA5=ncread('/Volumes/ExtremePro/WANG_SSD/ERA5_cloud/ERA5_cloudcover_all_polargrid.nc','var164',[1 1 104449+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   cloud_ERA5(isnan(data_satellite))=nan;
   data_cloud_ERA5_TCF_masked(:,:,i)=mean(cloud_ERA5,3,'omitnan'); 

   % add LCF mask here
   % add LCF cloud mask here
   cloud_ERA5=ncread('/Volumes/PostDoc_drive/ERA5_cloud_LHM/ERA5_LCF_polargrid.nc','LCC',[1 1 96433+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   cloud_ERA5(isnan(data_satellite))=nan;
   data_cloud_ERA5_LCF_masked(:,:,i)=mean(cloud_ERA5,3,'omitnan'); 

   % add MCF mask here
   % add MCF cloud mask here
   cloud_ERA5=ncread('/Volumes/PostDoc_drive/ERA5_cloud_LHM/ERA5_MCF_polargrid.nc','MCC',[1 1 96433+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   cloud_ERA5(isnan(data_satellite))=nan;
   data_cloud_ERA5_MCF_masked(:,:,i)=mean(cloud_ERA5,3,'omitnan'); 

   % add HCF mask here
   % add HCF cloud mask here
   cloud_ERA5=ncread('/Volumes/PostDoc_drive/ERA5_cloud_LHM/ERA5_HCF_polargrid.nc','HCC',[1 1 96433+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   cloud_ERA5(isnan(data_satellite))=nan;
   data_cloud_ERA5_HCF_masked(:,:,i)=mean(cloud_ERA5,3,'omitnan'); 

   i
end


for j=1:5
ERA5_TCF_mask=mean(data_cloud_ERA5_TCF_masked(:,:,X{j}),3,'omitnan');
cloud_ERA5_TCF_masked{j}=ERA5_TCF_mask;
ERA5_HCF_mask=mean(data_cloud_ERA5_HCF_masked(:,:,X{j}),3,'omitnan');
cloud_ERA5_HCF_masked{j}=ERA5_HCF_mask;
ERA5_MCF_mask=mean(data_cloud_ERA5_MCF_masked(:,:,X{j}),3,'omitnan');
cloud_ERA5_MCF_masked{j}=ERA5_MCF_mask;
ERA5_LCF_mask=mean(data_cloud_ERA5_LCF_masked(:,:,X{j}),3,'omitnan');
cloud_ERA5_LCF_masked{j}=ERA5_LCF_mask;
end

%save cloud_fra_clear_sky_ERA5_HML cloud_ERA5_*_masked
cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
load cloud_fra_clear_sky_ERA5_HML cloud_ERA5_*_masked

figure
%title_name={'May', 'Jun','Jul','Aug','Sep','Oct'};
data_name={'TCF','LCF','MCF','HCF'};
[ha, pos] = tight_subplot(1,4,[0 0],[.1 .1],[.1 .1]);
var={'TCF','LCF','MCF','HCF'};
q=1;
for j=1:4
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
        m_contourf(lons,lats,eval(['cloud_ERA5_',var{j},'_masked{1}']), 0:0.05:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        m_gshhs_l('color','k');
        caxis([0 1])
        colortable =textread('WhBlGrYeRe.txt');
        colormap(colortable(1:5:end,:));
        q=q+1;
        
         title(data_name{j},'FontSize',16,'Interpreter','none')
        
%         if j==1
%          ylabel(data_name{1},'FontSize',16,'fontweight','bold')
%         end
        %m_text(-43,-45,text_all{1}{j},'fontsize',18,'fontname','bold')
end


h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Cloud fraction';
set(h,'position',[.925 .25 .01 .5])


%% JRA3Q cloud fraction when MODIS clear sky

for i=1:length(x0)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   % add total cloud mask here
   cloud_JRA3Q=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_TCC_polargrid.nc','tcdc-tcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_JRA3Q=permute(cloud_JRA3Q,[2 1 3]);
   cloud_JRA3Q(isnan(data_satellite))=nan;
   data_cloud_JRA3Q_TCF_masked(:,:,i)=mean(cloud_JRA3Q,3,'omitnan'); 


   % add LCF mask here
   % add LCF cloud mask here
   cloud_JRA3Q=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_LCF_polargrid.nc','lcdc-lcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_JRA3Q=permute(cloud_JRA3Q,[2 1 3]);
   cloud_JRA3Q(isnan(data_satellite))=nan;
   data_cloud_JRA3Q_LCF_masked(:,:,i)=mean(cloud_JRA3Q,3,'omitnan'); 

   % add MCF mask here
   % add MCF cloud mask here
   cloud_JRA3Q=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_MCF_polargrid.nc','mcdc-mcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_JRA3Q=permute(cloud_JRA3Q,[2 1 3]);
   cloud_JRA3Q(isnan(data_satellite))=nan;
   data_cloud_JRA3Q_MCF_masked(:,:,i)=mean(cloud_JRA3Q,3,'omitnan'); 

   % add HCF mask here
   % add HCF cloud mask here
   cloud_JRA3Q=ncread('/Volumes/PostDoc_drive/JRA3Q/JRA3Q_HCF_polargrid.nc','hcdc-hcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_JRA3Q=permute(cloud_JRA3Q,[2 1 3]);
   cloud_JRA3Q(isnan(data_satellite))=nan;
   data_cloud_JRA3Q_HCF_masked(:,:,i)=mean(cloud_JRA3Q,3,'omitnan'); 

   i

end

for j=1:5
JRA3Q_TCF_mask=mean(data_cloud_JRA3Q_TCF_masked(:,:,X{j}),3,'omitnan');
cloud_JRA3Q_TCF_masked{j}=JRA3Q_TCF_mask./100;
JRA3Q_HCF_mask=mean(data_cloud_JRA3Q_HCF_masked(:,:,X{j}),3,'omitnan');
cloud_JRA3Q_HCF_masked{j}=JRA3Q_HCF_mask./100;
JRA3Q_MCF_mask=mean(data_cloud_JRA3Q_MCF_masked(:,:,X{j}),3,'omitnan');
cloud_JRA3Q_MCF_masked{j}=JRA3Q_MCF_mask./100;
JRA3Q_LCF_mask=mean(data_cloud_JRA3Q_LCF_masked(:,:,X{j}),3,'omitnan');
cloud_JRA3Q_LCF_masked{j}=JRA3Q_LCF_mask./100;
end

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
%save cloud_fra_clear_sky_JRA3Q_HML cloud_JRA3Q_*_masked
load cloud_fra_clear_sky_JRA3Q_HML cloud_JRA3Q_*_masked

figure
%title_name={'May', 'Jun','Jul','Aug','Sep','Oct'};
data_name={'TCF','LCF','MCF','HCF'};
[ha, pos] = tight_subplot(1,4,[0 0],[.1 .1],[.1 .1]);
var={'TCF','LCF','MCF','HCF'};
q=1;
for j=1:4
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
        m_contourf(lons,lats,eval(['cloud_JRA3Q_',var{j},'_masked{1}']), 0:0.05:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        m_gshhs_l('color','k');
        caxis([0 1])
        colortable =textread('WhBlGrYeRe.txt');
        colormap(colortable(1:5:end,:));
        q=q+1;
        
         title(data_name{j},'FontSize',16,'Interpreter','none')
        
%         if j==1
%          ylabel(data_name{1},'FontSize',16,'fontweight','bold')
%         end
        %m_text(-43,-45,text_all{1}{j},'fontsize',18,'fontname','bold')
end


h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Cloud fraction';
set(h,'position',[.925 .25 .01 .5])




