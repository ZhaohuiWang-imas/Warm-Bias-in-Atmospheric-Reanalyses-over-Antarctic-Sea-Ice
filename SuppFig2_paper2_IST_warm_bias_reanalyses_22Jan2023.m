% the second figure for paper 2 
% five line are the reanalysis seasonality (all and four seasons)
% each line is a reanalysis product

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

for j=1:5
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

end

%%add the 80% SIC line to each figures

% for j=1:5
% for i=1:length(X{j})
%    if datevec(X{j}(i),1)<=2007
%    seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(X{j}(i),:),'_f13_v04r00.nc'],'cdr_seaice_conc');
%    else
%    seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestr(X{j}(i),:),'_f17_v04r00.nc'],'cdr_seaice_conc');
%    end
%    seaice_cdr=seaice';
%    seaice_cdr(seaice_cdr>1)=nan;
%    seaice_cdr_all(:,:,i)=seaice_cdr;
% end
% seaice_cdr_mean=mean(seaice_cdr_all,3,'omitnan');
% seaice_conc_cdr_climitology{j}=seaice_cdr_mean;
% clear seaice_cdr_all
% end


cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')


text_no1={'(a)','(b)','(c)','(d)','(e)'};
text_no2={'(f)','(g)','(h)','(i)','(j)'};
text_no3={'(k)','(l)','(m)','(n)','(o)'};
text_no4={'(p)','(q)','(r)','(s)','(t)'};
text_no5={'(u)','(v)','(w)','(x)','(y)'};

figure
%set(gcf,'unit','normalized','position',[.1 .1 .6 .85])
data_name={'ERA5', 'ERAI', 'MERRA2', 'NCEPR2', 'JRA55','FNL'};
title_name={'ERA5', 'ERA-Interim', 'MERRA2', 'NCEPR2', 'JRA55','FNL'};
season={'ALL','JFM','AMJ','JAS','OND'};

for i=1:5
    for j=1
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
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

for i=1:5
    for j=2
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
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

for i=1:5
    for j=3
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
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

for i=1:5
    for j=4
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
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


for i=1:5
    for j=5
ax1=axes('position',[0.1+0.16*(i-1) 0.75-0.18*(j-1) .18 .18]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',50,'rectbox','on');
m_pcolor(lons,lats,eval([data_name{i},'_ME{j}']));
hold on
%m_contour(lons,lats,seaice_conc_cdr_climitology{j},[0.8 0.8],'k','LineWidth',2);
hold off
caxis([-15 15])
cmocean('balance',30)
m_gshhs_l('color','k');
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
h.Label.String = '\circC';
set(h,'position',[.92 .23 .01 .5])


% same figure also can be used for figure cloud 20%