% This is the figure 1 in the IST intercomparision manuscript

clear
%date of each experiment
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
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

cd /Users/zhaohuiw/Desktop

load('data_ME.mat')

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



load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')

text_no1={'(a)','(b)','(c)','(d)','(e)'};
text_no2={'(f)','(g)','(h)','(i)','(j)'};
text_no3={'(k)','(l)','(m)','(n)','(o)'};

figure
set(gcf,'unit','normalized','position',[0.0 0.0 1.0 .60]) % [left bottom width height]
data_name={'ERA5', 'ERAI', 'MERRA2', 'NCEPR2', 'JRA55','FNL'};
data_name_title={'ERA5', 'ERA-Interim', 'MERRA2', 'NCEPR2', 'JRA55','FNL'};
season={'ALL','JFM','AMJ','JAS','OND'};

% plot IST biases without TCF mask
for i=1:5
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
ylabel('MODIS cloud mask','FontSize',22,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no1{i},'fontsize',28,'fontname','bold')
end


% plot IST biases with 20% TCF mask

cd /Users/zhaohuiw/Desktop
load('data_ME_02cloud.mat')
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

for i=1:5
    for j=1
ax2=axes('position',[0.15*(i-1) 0.10 .37 .37]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
if i==1
ylabel('MODIS +TCF cloud mask','FontSize',22,'FontWeight','bold')
end
    end
m_text(-45,-45,text_no2{i},'fontsize',28,'fontname','bold')
end

h=colorbar('eastoutside');
set(h,'fontsize',25,'tickdir','out','linewidth',1)
h.Label.String = '\circC';
set(h,'position',[.87 .20 .01 .57])

%print(gcf, 'figure1_paper2_IST_bias_manuscript_version', '-dpdf', '-r300'); % 保存为PDF格式，分辨率为300 dpi
