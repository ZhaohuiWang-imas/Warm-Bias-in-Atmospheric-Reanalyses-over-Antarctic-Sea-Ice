clear
%date of each experiment
dates = datenum('01-Dec-2002'):datenum('30-Nov-2020');
%dates = [datenum('01-Jan-2002'):datenum('31-Dec-2020')]; % although we
%have such long time data aviliable, we use '01-Dec-2002' to '30-Nov-2020'
%to keep consistant with rest analysis
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);

%% This is the first line: the satellite data density
x0=(1:length(datevec))';
[x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
[x2,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
[x3,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
[x4,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
X={x0,x1,x2,x3,x4};

for j=1:5
for i=1:length(X{j})
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(X{j}(i),:),'.mat']) % resampling methods changed to Gauss
   data_satellite(~isnan(data_satellite))=1;
   data_density_satellite_hourly(:,:,i)=nansum(data_satellite,3);
   %data_density_satellite_6hourly(:,:,i)=nansum(data_satellite(:,:,1:6:end),3);   
end
data_density_satellite_hourly_season=nansum(data_density_satellite_hourly,3);
satellite_den_hourly{j}=data_density_satellite_hourly_season;
clear data_density_satellite_hourly

% data_density_satellite_6hourly_season=nansum(data_density_satellite_6hourly,3);
% satellite_den_6hourly{j}=data_density_satellite_6hourly_season;
% clear data_density_satellite_6hourly
end

%% this is the second line of the figure: the mean temperature from MODIS
% total
for i=1:length(datevec)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(i,:),'.mat'])
   data_satellite_tot(:,:,i)=nanmean(data_satellite,3); 
end
satellite_ME_tot=nanmean(data_satellite_tot,3);
clear data_satellite_tot
% DJF
[x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
for i=1:length(x1)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x1(i),:),'.mat'])
   data_satellite_DJF(:,:,i)=nanmean(data_satellite,3); 
end
satellite_ME_DJF=nanmean(data_satellite_DJF,3);
clear data_satellite_DJF
% MAM
[x1,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
for i=1:length(x1)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x1(i),:),'.mat'])
   data_satellite_MAM(:,:,i)=nanmean(data_satellite,3); 
end
satellite_ME_MAM=nanmean(data_satellite_MAM,3);
clear data_satellite_MAM
% JJA
[x1,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
for i=1:length(x1)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x1(i),:),'.mat'])
   data_satellite_JJA(:,:,i)=nanmean(data_satellite,3); 
end
satellite_ME_JJA=nanmean(data_satellite_JJA,3);
clear data_satellite_JJA
% SON
[x1,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
for i=1:length(x1)
   load(['/Volumes/ExtremePro/MODIS_gauss/modified_IST_satellite_clearsky_gauss17km/IST_satellite_',datestr(x1(i),:),'.mat'])
   data_satellite_SON(:,:,i)=nanmean(data_satellite,3); 
end
satellite_ME_SON=nanmean(data_satellite_SON,3);
clear data_satellite_SON

Satellite_ME={'satellite_ME_tot','satellite_ME_DJF','satellite_ME_MAM','satellite_ME_JJA','satellite_ME_SON'};

%% this is the third line of the figure:the climatology of sea ice concentration

x0=(1:length(datevec))';
[x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
[x2,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
[x3,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
[x4,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
X={x0,x1,x2,x3,x4};

for j=1:5
for i=1:length(X{j})
   if datevec(X{j}(i),1)<=2007
   seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(X{j}(i),:),'_f13_v04r00.nc'],'cdr_seaice_conc');
   else
   seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(X{j}(i),:),'_f17_v04r00.nc'],'cdr_seaice_conc');
   end
   seaice_cdr=seaice';
   seaice_cdr(seaice_cdr>1)=nan;
   seaice_cdr_all(:,:,i)=seaice_cdr;
end
seaice_cdr_mean=mean(seaice_cdr_all,3,'omitnan');
seaice_conc_cdr_climitology{j}=seaice_cdr_mean;
clear seaice_cdr_all
end

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')

%% plot using the new method
season={'All in 18 years','JFM','AMJ','JAS','OND'};
data_name={'hourly'};
text_no1={'(a)','(b)','(c)','(d)','(e)'};
text_no2={'(f)','(g)','(h)','(i)','(j)'};
text_no3={'(k)','(l)','(m)','(n)','(o)'};

figure
set(gcf,'unit','normalized','position',[.1 .08 .6 .85])
for i=1:5
    for j=1
ax1=axes('position',[0.1+0.16*(i-1) 0.7 .15 .20]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-88,'longitude',0,'radius',49,'rectbox','on');
m_pcolor(lons,lats,eval(['satellite_den_',data_name{j},'{i}./length(x',num2str(i-1),')']));
hold on
m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
hold off
caxis([-40 10])
%h=colorbar('eastoutside');
caxis([0 6])
cmocean('amp',24)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if i==1
    ylabel('Data density','FontSize',20)
end
title(season{i},'FontSize',20)
    end
m_text(-45,-45,text_no1{i},'fontsize',25,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
h.Label.String = 'hours/day';
set(h,'position',[.90 .71 .01 .18])

for i=1:5
    for j=1
ax2=axes('position',[0.1+0.16*(i-1) 0.5 .15 .20]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',0,'radius',49,'rectbox','on');
m_pcolor(lons,lats,eval([Satellite_ME{i},'-273.15']));
hold on
m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
hold off
caxis([-30 0])
cmocean('haline',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if i==1
    ylabel('Mean IST','FontSize',20)
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
        ax3=axes('position',[0.1+0.16*(i-1) 0.3 .15 .20]) % [left bottom width height]
        m_proj('azimuthal equal-area','latitude',-87,'longitude',0,'radius',49,'rectbox','on');
        m_pcolor(lons,lats,seaice_conc_cdr_climitology{i});
        hold on
        m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
        m_gshhs_l('color','k');
        caxis([0 1])
        colortable =textread('WhiteBlue.txt');
        colormap(ax3,colortable(1:5:end,:));
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if i==1
ylabel('Mean SIC','FontSize',20)
end
    end
m_text(-45,-45,text_no3{i},'fontsize',25,'fontname','bold')
end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
h.Label.String = 'fraction';
set(h,'position',[.90 .31 .01 .18])

