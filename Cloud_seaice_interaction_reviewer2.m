% This program used to analysis the interaction between cloud (different
% level) and sea ice in response to reviewer 2


% check the annual mean difference between WRF_var_nosnow_2m_bin_polargrid
% and WRF_var_nosnow_2m_fra_polargrid


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

% extract the cloud data
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_bin_polargrid.nc','CFRACT');
TCC_nosnow_2m_bin=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','CFRACT');
TCC_nosnow_2m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_15m_frac_polargrid.nc','CFRACT');
TCC_nosnow_15m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','CFRACT');
TCC_SIT_15m_SNOW_5_frac=permute(data,[2 1 3]);


cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')



%Annual seasonal mean cloud fraction difference

for i=1:length(x0)
   TCC_nosnow_2m_bin_per_day=TCC_nosnow_2m_bin(:,:,(i-1)*24+1:i*24);
   TCC_nosnow_2m_bin_daily(:,:,i)=mean((TCC_nosnow_2m_bin_per_day),3,'omitnan'); 

   TCC_nosnow_2m_fra_per_day=TCC_nosnow_2m_fra(:,:,(i-1)*24+1:i*24);
   TCC_nosnow_2m_fra_daily(:,:,i)=mean((TCC_nosnow_2m_fra_per_day),3,'omitnan'); 

   TCC_nosnow_15m_fra_per_day=TCC_nosnow_15m_fra(:,:,(i-1)*24+1:i*24);
   TCC_nosnow_15m_fra_daily(:,:,i)=mean((TCC_nosnow_15m_fra_per_day),3,'omitnan'); 

   TCC_SIT_15m_SNOW_5_frac_per_day=TCC_SIT_15m_SNOW_5_frac(:,:,(i-1)*24+1:i*24);
   TCC_SIT_15m_SNOW_5_fra_daily(:,:,i)=mean((TCC_SIT_15m_SNOW_5_frac_per_day),3,'omitnan'); 
end


for j=1:5
TCC_nosnow_2m_bin_season{j}=mean(TCC_nosnow_2m_bin_daily(:,:,X{j}),3,'omitnan');
TCC_nosnow_2m_fra_season{j}=mean(TCC_nosnow_2m_fra_daily(:,:,X{j}),3,'omitnan');
TCC_nosnow_15m_fra_season{j}=mean(TCC_nosnow_15m_fra_daily(:,:,X{j}),3,'omitnan');
TCC_SIT_15m_SNOW_5_fra_season{j}=mean(TCC_SIT_15m_SNOW_5_fra_daily(:,:,X{j}),3,'omitnan');
end


%Annual seasonal mean cloud fraction difference between each experiment and nosnow_2m_bin

text_all={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
data_name={'nosnow_2m_bin','nosnow_2m_fra','nosnow_15m_fra','SIT_15m_SNOW_5_fra'};
title_name={'nosnow 2m bin','nosnow 2m fra','nosnow 1.5m fra','SIT 1.5m SNOW 5cm fra'};
figure
[ha, pos] = tight_subplot(2,2,[.01 .015],[.01 .04],[.03 .1]);
for j=1:4
axes(ha(j));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
% number below used to change the season and/or annual mean
m_contourf(lons,lats,eval(['TCC_',data_name{j},'_season{1}'])-TCC_nosnow_2m_bin_season{1}, -1:0.01:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-0.2 0.2])
cmocean('balance',40)
title(title_name{j},'FontSize',18)
m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','Cloud fraction')
h.Label.String = 'Seasonal mean cloud fraction difference';
set(h,'position',[.925 .25 .01 .5])



% check the seasonality

text_no1={'(a)','(b)','(c)'};
text_no2={'(d)','(e)','(f)'};
text_no3={'(g)','(h)','(i)'};
text_no4={'(j)','(k)','(l)'};
text_no5={'(m)','(n)','(o)'};

figure
%set(gcf,'unit','normalized','position',[.1 .1 .6 .85])
data_name={'nosnow_15m_fra','nosnow_2m_fra','SIT_15m_SNOW_5_fra'};
title_name={'Quasi-ERA5 - Quasi-JRA55','Exp-SIT - Quasi-JRA55', 'Exp-SNOW - Quasi-JRA55'};
season={'ALL','JFM','AMJ','JAS','OND'};

for i=1:3
    for j=1
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_contourf(lons,lats,eval(['TCC_',data_name{i},'_season{1}'])-TCC_nosnow_2m_bin_season{1}, -1:0.01:1,'LineStyle','None');
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
m_gshhs_l('color','k');
caxis([-0.2 0.2])
cmocean('balance',40)
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if j==1
title(title_name{i},'FontSize',16)
end
if i==1
ylabel(season{j},'FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no1{i},'fontsize',25,'fontname','bold')
end

for i=1:3
    for j=2
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_contourf(lons,lats,eval(['TCC_',data_name{i},'_season{2}'])-TCC_nosnow_2m_bin_season{2}, -1:0.01:1,'LineStyle','None');
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
m_gshhs_l('color','k');
caxis([-0.2 0.2])
cmocean('balance',40)
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if j==1
title(title_name{i},'FontSize',16)
end
if i==1
ylabel(season{j},'FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no2{i},'fontsize',25,'fontname','bold')
end

for i=1:3
    for j=3
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_contourf(lons,lats,eval(['TCC_',data_name{i},'_season{3}'])-TCC_nosnow_2m_bin_season{3}, -1:0.01:1,'LineStyle','None');
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
m_gshhs_l('color','k');
caxis([-0.2 0.2])
cmocean('balance',40)
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if j==1
title(title_name{i},'FontSize',16)
end
if i==1
ylabel(season{j},'FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no3{i},'fontsize',25,'fontname','bold')
end

for i=1:3
    for j=4
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_contourf(lons,lats,eval(['TCC_',data_name{i},'_season{4}'])-TCC_nosnow_2m_bin_season{4}, -1:0.01:1,'LineStyle','None');
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
m_gshhs_l('color','k');
caxis([-0.2 0.2])
cmocean('balance',40)
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if j==1
title(title_name{i},'FontSize',16)
end
if i==1
ylabel(season{j},'FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no4{i},'fontsize',25,'fontname','bold')
end


for i=1:3
    for j=5
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_contourf(lons,lats,eval(['TCC_',data_name{i},'_season{5}'])-TCC_nosnow_2m_bin_season{5}, -1:0.01:1,'LineStyle','None');
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
m_gshhs_l('color','k');
caxis([-0.2 0.2])
cmocean('balance',40)
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if j==1
title(title_name{i},'FontSize',16)
end
if i==1
ylabel(season{j},'FontSize',16,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no5{i},'fontsize',25,'fontname','bold')
end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
h.Label.String = 'Seasonal mean cloud fraction difference';
set(h,'position',[.72 .23 .01 .5])



%% we have found cloud fraction have difference, how these cloud difference influence 


%% LWDNB
cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools
load('lon25.mat')
load('lat25.mat')
% extract the LWDNB
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_bin_polargrid.nc','LWDNB');
LWDNB_nosnow_2m_bin=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','LWDNB');
LWDNB_nosnow_2m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_15m_frac_polargrid.nc','LWDNB');
LWDNB_nosnow_15m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','LWDNB');
LWDNB_SIT_15m_SNOW_5_frac=permute(data,[2 1 3]);


%Daily mean of LWDNB
for i=1:length(x0)
   LWDNB_nosnow_2m_bin_per_day=LWDNB_nosnow_2m_bin(:,:,(i-1)*24+1:i*24);
   LWDNB_nosnow_2m_bin_daily(:,:,i)=mean((LWDNB_nosnow_2m_bin_per_day),3,'omitnan'); 

   LWDNB_nosnow_2m_fra_per_day=LWDNB_nosnow_2m_fra(:,:,(i-1)*24+1:i*24);
   LWDNB_nosnow_2m_fra_daily(:,:,i)=mean((LWDNB_nosnow_2m_fra_per_day),3,'omitnan'); 

   LWDNB_nosnow_15m_fra_per_day=LWDNB_nosnow_15m_fra(:,:,(i-1)*24+1:i*24);
   LWDNB_nosnow_15m_fra_daily(:,:,i)=mean((LWDNB_nosnow_15m_fra_per_day),3,'omitnan'); 

   LWDNB_SIT_15m_SNOW_5_frac_per_day=LWDNB_SIT_15m_SNOW_5_frac(:,:,(i-1)*24+1:i*24);
   LWDNB_SIT_15m_SNOW_5_fra_daily(:,:,i)=mean((LWDNB_SIT_15m_SNOW_5_frac_per_day),3,'omitnan'); 
end


for j=1:5
LWDNB_nosnow_2m_bin_season{j}=mean(LWDNB_nosnow_2m_bin_daily(:,:,X{j}),3,'omitnan');
LWDNB_nosnow_2m_fra_season{j}=mean(LWDNB_nosnow_2m_fra_daily(:,:,X{j}),3,'omitnan');
LWDNB_nosnow_15m_fra_season{j}=mean(LWDNB_nosnow_15m_fra_daily(:,:,X{j}),3,'omitnan');
LWDNB_SIT_15m_SNOW_5_fra_season{j}=mean(LWDNB_SIT_15m_SNOW_5_fra_daily(:,:,X{j}),3,'omitnan');
end


%Annual seasonal mean downward longwave radiation difference between each experiment and nosnow_2m_bin

text_all={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
data_name={'nosnow_2m_bin','nosnow_2m_fra','nosnow_15m_fra','SIT_15m_SNOW_5_fra'};
title_name={'nosnow 2m bin','nosnow 2m fra','nosnow 1.5m fra','SIT 1.5m SNOW 5cm fra'};
figure
[ha, pos] = tight_subplot(2,2,[.01 .015],[.01 .04],[.03 .1]);
for j=1:4
axes(ha(j));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
% number below used to change the season and/or annual mean
m_contourf(lons,lats,eval(['LWDNB_',data_name{j},'_season{1}'])-LWDNB_nosnow_2m_bin_season{1}, -20:1:20,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',20)
title(title_name{j},'FontSize',18)
m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','Cloud fraction')
h.Label.String = 'Seasonal mean cloud fraction difference';
set(h,'position',[.925 .25 .01 .5])

%% LWUPB

% extract the LWUPB
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_bin_polargrid.nc','LWUPB');
LWUPB_nosnow_2m_bin=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','LWUPB');
LWUPB_nosnow_2m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_15m_frac_polargrid.nc','LWUPB');
LWUPB_nosnow_15m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','LWUPB');
LWUPB_SIT_15m_SNOW_5_frac=permute(data,[2 1 3]);


%Daily mean of LWUPB
for i=1:length(x0)
   LWUPB_nosnow_2m_bin_per_day=LWUPB_nosnow_2m_bin(:,:,(i-1)*24+1:i*24);
   LWUPB_nosnow_2m_bin_daily(:,:,i)=mean((LWUPB_nosnow_2m_bin_per_day),3,'omitnan'); 

   LWUPB_nosnow_2m_fra_per_day=LWUPB_nosnow_2m_fra(:,:,(i-1)*24+1:i*24);
   LWUPB_nosnow_2m_fra_daily(:,:,i)=mean((LWUPB_nosnow_2m_fra_per_day),3,'omitnan'); 

   LWUPB_nosnow_15m_fra_per_day=LWUPB_nosnow_15m_fra(:,:,(i-1)*24+1:i*24);
   LWUPB_nosnow_15m_fra_daily(:,:,i)=mean((LWUPB_nosnow_15m_fra_per_day),3,'omitnan'); 

   LWUPB_SIT_15m_SNOW_5_frac_per_day=LWUPB_SIT_15m_SNOW_5_frac(:,:,(i-1)*24+1:i*24);
   LWUPB_SIT_15m_SNOW_5_fra_daily(:,:,i)=mean((LWUPB_SIT_15m_SNOW_5_frac_per_day),3,'omitnan'); 
end


for j=1:5
LWUPB_nosnow_2m_bin_season{j}=mean(LWUPB_nosnow_2m_bin_daily(:,:,X{j}),3,'omitnan');
LWUPB_nosnow_2m_fra_season{j}=mean(LWUPB_nosnow_2m_fra_daily(:,:,X{j}),3,'omitnan');
LWUPB_nosnow_15m_fra_season{j}=mean(LWUPB_nosnow_15m_fra_daily(:,:,X{j}),3,'omitnan');
LWUPB_SIT_15m_SNOW_5_fra_season{j}=mean(LWUPB_SIT_15m_SNOW_5_fra_daily(:,:,X{j}),3,'omitnan');
end

%Annual seasonal mean upward longwave radiation difference between each experiment and nosnow_2m_bin

text_all={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
data_name={'nosnow_2m_bin','nosnow_2m_fra','nosnow_15m_fra','SIT_15m_SNOW_5_fra'};
title_name={'nosnow 2m bin','nosnow 2m fra','nosnow 1.5m fra','SIT 1.5m SNOW 5cm fra'};
figure
[ha, pos] = tight_subplot(2,2,[.01 .015],[.01 .04],[.03 .1]);
for j=1:4
axes(ha(j));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
% number below used to change the season and/or annual mean
m_contourf(lons,lats,eval(['LWUPB_',data_name{j},'_season{1}'])-LWUPB_nosnow_2m_bin_season{1}, -20:1:20,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',20)
title(title_name{j},'FontSize',18)
m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','Cloud fraction')
h.Label.String = 'Seasonal mean cloud fraction difference';
set(h,'position',[.925 .25 .01 .5])


%% HFX

% extract the HFX
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_bin_polargrid.nc','HFX');
HFX_nosnow_2m_bin=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','HFX');
HFX_nosnow_2m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_15m_frac_polargrid.nc','HFX');
HFX_nosnow_15m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','HFX');
HFX_SIT_15m_SNOW_5_frac=permute(data,[2 1 3]);


%Daily mean of LWDNB
for i=1:length(x0)
   HFX_nosnow_2m_bin_per_day=HFX_nosnow_2m_bin(:,:,(i-1)*24+1:i*24);
   HFX_nosnow_2m_bin_daily(:,:,i)=mean((HFX_nosnow_2m_bin_per_day),3,'omitnan'); 

   HFX_nosnow_2m_fra_per_day=HFX_nosnow_2m_fra(:,:,(i-1)*24+1:i*24);
   HFX_nosnow_2m_fra_daily(:,:,i)=mean((HFX_nosnow_2m_fra_per_day),3,'omitnan'); 

   HFX_nosnow_15m_fra_per_day=HFX_nosnow_15m_fra(:,:,(i-1)*24+1:i*24);
   HFX_nosnow_15m_fra_daily(:,:,i)=mean((HFX_nosnow_15m_fra_per_day),3,'omitnan'); 

   HFX_SIT_15m_SNOW_5_frac_per_day=HFX_SIT_15m_SNOW_5_frac(:,:,(i-1)*24+1:i*24);
   HFX_SIT_15m_SNOW_5_fra_daily(:,:,i)=mean((HFX_SIT_15m_SNOW_5_frac_per_day),3,'omitnan'); 
end


for j=1:5
HFX_nosnow_2m_bin_season{j}=mean(HFX_nosnow_2m_bin_daily(:,:,X{j}),3,'omitnan');
HFX_nosnow_2m_fra_season{j}=mean(HFX_nosnow_2m_fra_daily(:,:,X{j}),3,'omitnan');
HFX_nosnow_15m_fra_season{j}=mean(HFX_nosnow_15m_fra_daily(:,:,X{j}),3,'omitnan');
HFX_SIT_15m_SNOW_5_fra_season{j}=mean(HFX_SIT_15m_SNOW_5_fra_daily(:,:,X{j}),3,'omitnan');
end


%Annual seasonal mean sensible heat flux difference between each experiment and nosnow_2m_bin

text_all={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
data_name={'nosnow_2m_bin','nosnow_2m_fra','nosnow_15m_fra','SIT_15m_SNOW_5_fra'};
title_name={'nosnow 2m bin','nosnow 2m fra','nosnow 1.5m fra','SIT 1.5m SNOW 5cm fra'};
figure
[ha, pos] = tight_subplot(2,2,[.01 .015],[.01 .04],[.03 .1]);
for j=1:4
axes(ha(j));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
% number below used to change the season and/or annual mean
m_contourf(lons,lats,eval(['HFX_',data_name{j},'_season{1}'])-HFX_nosnow_2m_bin_season{1}, -20:1:20,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',20)
title(title_name{j},'FontSize',18)
m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','Cloud fraction')
h.Label.String = 'Seasonal mean cloud fraction difference';
set(h,'position',[.925 .25 .01 .5])



%% LF

% extract the LH
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_bin_polargrid.nc','LH');
LH_nosnow_2m_bin=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','LH');
LH_nosnow_2m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_15m_frac_polargrid.nc','LH');
LH_nosnow_15m_fra=permute(data,[2 1 3]);
data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','LH');
LH_SIT_15m_SNOW_5_frac=permute(data,[2 1 3]);


%Daily mean of LWDNB
for i=1:length(x0)
   LH_nosnow_2m_bin_per_day=LH_nosnow_2m_bin(:,:,(i-1)*24+1:i*24);
   LH_nosnow_2m_bin_daily(:,:,i)=mean((LH_nosnow_2m_bin_per_day),3,'omitnan'); 

   LH_nosnow_2m_fra_per_day=LH_nosnow_2m_fra(:,:,(i-1)*24+1:i*24);
   LH_nosnow_2m_fra_daily(:,:,i)=mean((LH_nosnow_2m_fra_per_day),3,'omitnan'); 

   LH_nosnow_15m_fra_per_day=LH_nosnow_15m_fra(:,:,(i-1)*24+1:i*24);
   LH_nosnow_15m_fra_daily(:,:,i)=mean((LH_nosnow_15m_fra_per_day),3,'omitnan'); 

   LH_SIT_15m_SNOW_5_frac_per_day=LH_SIT_15m_SNOW_5_frac(:,:,(i-1)*24+1:i*24);
   LH_SIT_15m_SNOW_5_fra_daily(:,:,i)=mean((LH_SIT_15m_SNOW_5_frac_per_day),3,'omitnan'); 
end


for j=1:5
LH_nosnow_2m_bin_season{j}=mean(LH_nosnow_2m_bin_daily(:,:,X{j}),3,'omitnan');
LH_nosnow_2m_fra_season{j}=mean(LH_nosnow_2m_fra_daily(:,:,X{j}),3,'omitnan');
LH_nosnow_15m_fra_season{j}=mean(LH_nosnow_15m_fra_daily(:,:,X{j}),3,'omitnan');
LH_SIT_15m_SNOW_5_fra_season{j}=mean(LH_SIT_15m_SNOW_5_fra_daily(:,:,X{j}),3,'omitnan');
end

%Annual seasonal mean latent heat flux difference between each experiment and nosnow_2m_bin

text_all={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
data_name={'nosnow_2m_bin','nosnow_2m_fra','nosnow_15m_fra','SIT_15m_SNOW_5_fra'};
title_name={'nosnow 2m bin','nosnow 2m fra','nosnow 1.5m fra','SIT 1.5m SNOW 5cm fra'};
figure
[ha, pos] = tight_subplot(2,2,[.01 .015],[.01 .04],[.03 .1]);
for j=1:4
axes(ha(j));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
% number below used to change the season and/or annual mean
m_contourf(lons,lats,eval(['HFX_',data_name{j},'_season{1}'])-HFX_nosnow_2m_bin_season{1}, -20:1:20,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([-10 10])
cmocean('balance',20)
title(title_name{j},'FontSize',18)
m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','Cloud fraction')
h.Label.String = 'Seasonal mean cloud fraction difference';
set(h,'position',[.925 .25 .01 .5])

