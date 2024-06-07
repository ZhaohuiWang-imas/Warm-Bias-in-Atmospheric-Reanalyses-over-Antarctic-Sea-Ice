clear
%date of each experiment
dates = datenum('01-Dec-2002'):datenum('30-Nov-2020');
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);

% x0=(1:length(datevec))';
% [x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
% [x2,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
% [x3,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
% [x4,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
% X={x0,x1,x2,x3,x4};

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice

load('JRA55_radiation_less10w.mat', 'JRA55_dlwrf_season')
load('JRA55_radiation_less10w.mat', 'JRA55_dswrf_season')
load('JRA55_radiation_less10w.mat', 'JRA55_lhf_season')
load('JRA55_radiation_less10w.mat', 'JRA55_shf_season')
load('JRA55_radiation_less10w.mat', 'JRA55_ulwrf_season')
load('JRA55_radiation_less10w.mat', 'JRA55_uswrf_season')

load('ERA5_radiation_less10w.mat', 'ERA5_dlwrf_season')
load('ERA5_radiation_less10w.mat', 'ERA5_dswrf_season')
load('ERA5_radiation_less10w.mat', 'ERA5_lhf_season')
load('ERA5_radiation_less10w.mat', 'ERA5_shf_season')
load('ERA5_radiation_less10w.mat', 'ERA5_ulwrf_season')
load('ERA5_radiation_less10w.mat', 'ERA5_uswrf_season')

% ﻿ice heat conduction term
i=2
R_ERA5=-(ERA5_uswrf_season{i}+ERA5_ulwrf_season{i}-ERA5_dswrf_season{i}-ERA5_dlwrf_season{i}+ERA5_lhf_season{1}+ERA5_shf_season{i});
R_JRA55=-(JRA55_uswrf_season{i}+JRA55_ulwrf_season{i}-JRA55_dswrf_season{i}-JRA55_dlwrf_season{i}+JRA55_lhf_season{i}+JRA55_shf_season{i});
R(:,:,1)=R_ERA5; R(:,:,2)=R_JRA55;

title_name={'Ice heat conduction in ERA5','Ice heat conduction in JRA55','Diff (ERA5 - JRA55)'};
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

%% calculate the domain-averge ice heat conduction from model

 load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    ERA5_domain=sum(R(:,:,1).*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R(:,:,1))),'all','omitnan');
    JRA55_domain=sum(R(:,:,2).*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R(:,:,2))),'all','omitnan');
    Diff_domain=sum((R(:,:,1)-R(:,:,2)).*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(R(:,:,1)-R(:,:,2))),'all','omitnan');

    % -34.9866 for JRA55, -52.7503 for ERA5, -17.7705 for diff
