% Compare MODIS with VIIRS

clear
%date of each experiment
dates = [datenum('01-Jan-2018'):datenum('31-Dec-2018')];
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

   %JRA3Q
    JRA3Q_LWD_per_day=ncread('/Volumes/PostDoc_backup/JRA3Q/JRA3Q_LWD_polargrid.nc','dlwrf1have-sfc-fc-gauss',[1 1 35809+24*(i-1)],[Inf Inf 24]);
    JRA3Q_LWU_per_day=ncread('/Volumes/PostDoc_backup/JRA3Q/JRA3Q_LWU_polargrid.nc','ulwrf1have-sfc-fc-gauss',[1 1 35809+24*(i-1)],[Inf Inf 24]);
    JRA3Q_skt=nthroot((JRA3Q_LWU_per_day-(1-0.99).*JRA3Q_LWD_per_day)./(0.99.*5.67.*(10^(-8))),4);
    JRA3Q_skt(JRA3Q_skt==0)=nan;
    data_JRA3Q=permute(JRA3Q_skt,[2 1 3]);
    data_ME_JRA3Q(:,:,i)=mean(data_JRA3Q-data_satellite,3,'omitnan'); 
   
end



%This code used to generate the useful VIIRS IST
% % useful IST of VIIRS
% for date =1:365
% if datevec(date,1)<=2007
% seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(date,:),'_f13_v04r00.nc'],'cdr_seaice_conc');
% else
% seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(date,:),'_f17_v04r00.nc'],'cdr_seaice_conc');
% end
% seaice_cdr=seaice';
% seaice_cdr(seaice_cdr>1)=0;
% %%VIIRS
% eval(['load /Volumes/PostDoc_drive/VNP30_hourly_gauss17km/2018/VNP30_',datestr(date,:)])
% for i=1:24
% data_hour=data_that_hours(:,:,i);
% data_hour(seaice_cdr<0.8)=0;
% data_hour(isnan(seaice_cdr))=0;
% data_VIIRS(:,:,i)=data_hour;
% end
% data_VIIRS(data_VIIRS==0)=nan;
% data_satellite=data_VIIRS;
% save(['/Volumes/PostDoc_drive/VNP30_hourly_gauss17km/VIIRS_modified_IST_satellite_gauss17km/IST_satellite_',datestr(date,:),'.mat'],'data_satellite')
% end



for i=1:length(x0)
   load(['/Volumes/PostDoc_drive/VNP30_hourly_gauss17km/VIIRS_modified_IST_satellite_gauss17km/IST_satellite_',datestr(x0(i),:),'.mat'])
   
   % ERA5
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERA5/ERA5_regrid',datestr(x0(i),:),'.mat'])
   data_ERA5=permute(data,[2 3 1]);
   data_ERA5(data_ERA5==0)=nan;
   data_ME_ERA5_VIIRS(:,:,i)=mean(data_ERA5-data_satellite,3,'omitnan'); 
   

   % MERRA2
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/MERRA2/MERRA2_regrid',datestr(x0(i),:),'.mat'])
   data_MERRA2=permute(data,[2 3 1]);
   data_MERRA2(data_MERRA2==0)=nan;
   data_ME_MERRA2_VIIRS(:,:,i)=mean(data_MERRA2-data_satellite,3,'omitnan'); 
   
   % NCEP2
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/NCEPR2/NCEPR2_regrid',datestr(x0(i),:),'.mat'])
   data_NCEPR2=permute(data,[2 3 1]);
   data_NCEPR2(data_NCEPR2==0)=nan;
   data_ME_NCEPR2_VIIRS(:,:,i)=mean(data_NCEPR2-data_satellite(:,:,1:6:end),3,'omitnan'); 
   
   % ERAI
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/ERAI/ERAI_regrid',datestr(x0(i),:),'.mat'])
   data_ERAI=permute(data,[2 3 1]);
   data_ERAI(data_ERAI==0)=nan;
   data_ME_ERAI_VIIRS(:,:,i)=mean(data_ERAI-data_satellite(:,:,1:6:end),3,'omitnan'); 

   % JRA55
   load(['/Volumes/ExtremePro/WANG_SSD/regridded_reanalysis_2002_2020/JRA55_skt/JRA55_regrid',datestr(x0(i),:),'.mat'])
   data_JRA55=permute(JRA55_skt,[3 4 2 1]);
   data_JRA55=reshape(data_JRA55,[332,316,8]);
   data_JRA55(data_JRA55==0)=nan;
   for fr=1:8
   data_satellite_JRA55(:,:,fr)=mean(data_satellite(:,:,fr*3-2:fr*3),3,'omitnan');
   end
   data_ME_JRA55_VIIRS(:,:,i)=mean(data_JRA55-data_satellite_JRA55,3,'omitnan'); 

   %JRA3Q
    JRA3Q_LWD_per_day=ncread('/Volumes/PostDoc_backup/JRA3Q/JRA3Q_LWD_polargrid.nc','dlwrf1have-sfc-fc-gauss',[1 1 35809+24*(i-1)],[Inf Inf 24]);
    JRA3Q_LWU_per_day=ncread('/Volumes/PostDoc_backup/JRA3Q/JRA3Q_LWU_polargrid.nc','ulwrf1have-sfc-fc-gauss',[1 1 35809+24*(i-1)],[Inf Inf 24]);
    JRA3Q_skt=nthroot((JRA3Q_LWU_per_day-(1-0.99).*JRA3Q_LWD_per_day)./(0.99.*5.67.*(10^(-8))),4);
    JRA3Q_skt(JRA3Q_skt==0)=nan;
    data_JRA3Q=permute(JRA3Q_skt,[2 1 3]);
    data_ME_JRA3Q_VIIRS(:,:,i)=mean(data_JRA3Q-data_satellite,3,'omitnan'); 
   
end


%MODIS
% only considering the annual mean; so only choose the j=1
j=1;
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME{j}=ERA5_ME_season;

MERRA2_ME_season=nanmean(data_ME_MERRA2(:,:,X{j}),3);
MERRA2_ME{j}=MERRA2_ME_season;

NCEPR2_ME_season=nanmean(data_ME_NCEPR2(:,:,X{j}),3);
NCEPR2_ME{j}=NCEPR2_ME_season;

ERAI_ME_season=nanmean(data_ME_ERAI(:,:,X{j}(X{j}<=6118)),3);
ERAI_ME{j}=ERAI_ME_season;

JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME{j}=JRA55_ME_season;

JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME{j}=JRA3Q_ME_season;


load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')

text_no1={'(a)','(b)','(c)','(d)','(e)'};
text_no2={'(f)','(g)','(h)','(i)','(j)'};
text_no3={'(k)','(l)','(m)','(n)','(o)'};

figure
set(gcf,'unit','normalized','position',[0.0 0.0 1.0 .60]) % [left bottom width height]
data_name={'ERA5', 'ERAI', 'MERRA2', 'NCEPR2', 'JRA55','JRA3Q'};
data_name_title={'ERA5', 'ERA-Interim', 'MERRA2', 'NCEPR2', 'JRA55','JRA3Q'};
season={'ALL','JFM','AMJ','JAS','OND'};


for i=1:6
    for j=1
ax1=axes('position',[0.15*(i-1) 0.50 .37 .37]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if j==1
title(data_name_title{i},'FontSize',20)
end
if i==1
ylabel('MODIS IST','FontSize',22,'FontWeight','bold')
end

    end
%m_text(-45,-45,text_no1{i},'fontsize',28,'fontname','bold')
end


%VIIRS
% only considering the annual mean; so only choose the j=1
j=1;
ERA5_ME_season_VIIRS=nanmean(data_ME_ERA5_VIIRS(:,:,X{j}),3);
ERA5_ME_VIIRS{j}=ERA5_ME_season_VIIRS;

MERRA2_ME_season_VIIRS=nanmean(data_ME_MERRA2_VIIRS(:,:,X{j}),3);
MERRA2_ME_VIIRS{j}=MERRA2_ME_season_VIIRS;

NCEPR2_ME_season_VIIRS=nanmean(data_ME_NCEPR2_VIIRS(:,:,X{j}),3);
NCEPR2_ME_VIIRS{j}=NCEPR2_ME_season_VIIRS;

ERAI_ME_season_VIIRS=nanmean(data_ME_ERAI_VIIRS(:,:,X{j}(X{j}<=6118)),3);
ERAI_ME_VIIRS{j}=ERAI_ME_season_VIIRS;

JRA55_ME_season_VIIRS=nanmean(data_ME_JRA55_VIIRS(:,:,X{j}),3);
JRA55_ME_VIIRS{j}=JRA55_ME_season_VIIRS;

JRA3Q_ME_season_VIIRS=nanmean(data_ME_JRA3Q_VIIRS(:,:,X{j}),3);
JRA3Q_ME_VIIRS{j}=JRA3Q_ME_season_VIIRS;

for i=1:6
    for j=1
ax2=axes('position',[0.15*(i-1) 0.10 .37 .37]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME_VIIRS{j}']));
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if i==1
ylabel('VIIRS IST','FontSize',22,'FontWeight','bold')
end
    end
%m_text(-45,-45,text_no2{i},'fontsize',28,'fontname','bold')
end

h=colorbar('eastoutside');
set(h,'fontsize',25,'tickdir','out','linewidth',1)
h.Label.String = '\circC';
set(h,'position',[.87 .20 .01 .57])

%print(gcf, 'figure1_paper2_IST_bias_manuscript_version', '-dpdf', '-r300'); % 保存为PDF格式，分辨率为300 dpi


%% plot for manuscript
text_no1={'(a)','(b)','(c)','(d)','(e)', '(f)'};
text_no2={'(g)','(h)','(i)','(j)','(k)','(l)'};

figure
set(gcf,'unit','normalized','position',[0.0 0.0 0.6 .90]) % [left bottom width height]
data_name={'ERA5', 'ERAI', 'MERRA2', 'JRA3Q','NCEPR2', 'JRA55'};
data_name_title={'ERA5', 'ERA-Interim', 'MERRA-2', 'JRA-3Q','NCEPR2', 'JRA-55'};
season={'ALL','JFM','AMJ','JAS','OND'};
% plot IST biases without TCF mask
for i=1:6
if i <= 3
row = 1;
col = i;
else
row = 2;
col = i - 3;
end
for j=1
ax1=axes('position',[0.20*(col-1)+0.05 0.75-0.22*(row-1) .27 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
title(data_name_title{i},'FontSize',20)

end
m_text(-45,-45,text_no1{i},'fontsize',28,'fontname','bold')
end

% plot IST biases without TCF mask
for i=1:6
if i <= 3
row = 1;
col = i;
else
row = 2;
col = i - 3;
end
for j=1
ax2=axes('position',[0.20*(col-1)+0.05 0.29-0.22*(row-1) .27 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME_VIIRS{j}']));
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
title(data_name_title{i},'FontSize',20)

end
m_text(-45,-45,text_no2{i},'fontsize',28,'fontname','bold')
end


h=colorbar('eastoutside');
set(h,'fontsize',25,'tickdir','out','linewidth',1)
h.Label.String = '\circC';
set(h,'position',[.70 .20 .01 .57])

%print(gcf, 'figure1_paper2_IST_bias_manuscript_version', '-dpdf', '-r300'); % 保存为PDF格式，分辨率为300 dpi

m_text(0.05,0.05,'MODIS IST','fontsize',28,'fontweight','bold','rotation',90,'horizontalalignment','center','units','normalized')

m_text(0.05,0.05,'VIIRS IST','fontsize',28,'fontweight','bold','rotation',90,'horizontalalignment','center','units','normalized')

%% plot end

% now we calculate the domain average for each IST bias
% whatever vs VIIRS or MODIS

 load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    ERA5_ME_domainIST_MODIS=sum(ERA5_ME{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ME{1})),'all','omitnan');
    ERA5_ME_domainIST_VIIRS=sum(ERA5_ME_VIIRS{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ME_VIIRS{1})),'all','omitnan');

    JRA55_ME_domainIST_MODIS=sum(JRA55_ME{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ME{1})),'all','omitnan');
    JRA55_ME_domainIST_VIIRS=sum(JRA55_ME_VIIRS{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ME_VIIRS{1})),'all','omitnan');
    
    JRA3Q_ME_domainIST_MODIS=sum(JRA3Q_ME{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA3Q_ME{1})),'all','omitnan');
    JRA3Q_ME_domainIST_VIIRS=sum(JRA3Q_ME_VIIRS{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA3Q_ME_VIIRS{1})),'all','omitnan');
    


% ERA5_ME_domainIST_MODIS =
% 
%     4.8777
% 
% 
% ERA5_ME_domainIST_VIIRS =
% 
%     4.9256
% 
% 
% JRA55_ME_domainIST_MODIS =
% 
%    -0.4073
% 
% 
% JRA55_ME_domainIST_VIIRS =
% 
%    -0.6144
%
%JRA3Q_ME_domainIST_MODIS =
%
%    4.6726
%
%JRA3Q_ME_domainIST_VIIRS =
%    4.7848

