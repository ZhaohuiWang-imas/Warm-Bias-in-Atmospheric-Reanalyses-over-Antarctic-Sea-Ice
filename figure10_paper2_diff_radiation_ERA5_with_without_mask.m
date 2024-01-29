

clear
%date of each experiment
dates = datenum('01-Dec-2002'):datenum('30-Nov-2020');
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);

x0=(1:length(datevec))';
[x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
[x2,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
[x3,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
[x4,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
X={x0,x1,x2,x3,x4};

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')

%%
figure
[ha, pos] = tight_subplot(2,2,[0.01 0.02],[0.05 0.05],[.13 .13]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf'};
title_name={'ERA5 net shortwave diff','ERA5 net longwave diff','ERA5 net radiation flux diff', 'ERA5 IST bias diff'};
season={'ERA5 no TCC mask','ERA5 with TCC mask','ERA5 mask - no mask'};
text_all={'(a)','(b)','(c)','(d)'};
q=1;
    for j=1:3
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
        if j==3
        m_pcolor(lons,lats,-((ERA5_uswrf_season{1}+ERA5_ulwrf_season{1}-ERA5_dswrf_season{1}-ERA5_dlwrf_season{1})-(ERA5_uswrf_season_allsky{1}+ERA5_ulwrf_season_allsky{1}-ERA5_dswrf_season_allsky{1}-ERA5_dlwrf_season_allsky{1})));
        else
        m_pcolor(lons,lats,eval(['-(ERA5_',data_name{2*j},'_season{1}','-','ERA5_',data_name{2*j-1},'_season{1}','-','ERA5_',data_name{2*j},'_season_allsky{1}','+','ERA5_',data_name{2*j-1},'_season_allsky{1})']));
        end
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',60)
        q=q+1;
        title(title_name{j},'FontSize',18,'Interpreter','none')
        m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
        h=colorbar('eastoutside');
        set(h,'fontsize',18,'tickdir','out','linewidth',1)
        set(get(h,'Title'),'string','W m^-^2')
    end

axes(ha(4));
load('data_ME.mat', 'data_ME_ERA5')
ERA5_ME=mean(data_ME_ERA5,3,'omitnan');
load('data_ME_02cloud.mat', 'data_ME_ERA5')
ERA5_ME_clearsky=mean(data_ME_ERA5,3,'omitnan');

m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_pcolor(lons,lats,(ERA5_ME_clearsky-ERA5_ME));
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
cmocean('balance',30)
caxis([-5 5])
title(title_name{4},'FontSize',18)
m_text(-43,-45,text_all{4},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','K')

%%
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
set(get(h,'Title'),'string','Bias (K)')
%h.Label.String = '\circC';
set(h,'position',[.905 .39 .01 .5])

%%

%correlation in net longwave diff and IST bias diff 

a=-(ERA5_ME_clearsky-ERA5_ME);
a=reshape(a,[332*316 1]);
j=2;
b=eval(['ERA5_',data_name{2*j},'_season{1}','-','ERA5_',data_name{2*j-1},'_season{1}','-','ERA5_',data_name{2*j},'_season_allsky{1}','+','ERA5_',data_name{2*j-1},'_season_allsky{1}']);
b=reshape(b,[332*316 1]);
[rho,pval] = corr(a_nonan,b_nonan,'Type','Pearson'); 

%01Dec2023: the pattern correclation between longwave diff and IST bias
%diff are calculated by NCL.



%01 Dec2023: investigate the relationship between (SWD-SWU+LWD) difference
%and IST bias difference before and after clouyd mask


cd /Volumes/ExtremePro/Extreme_SSD/radiation_output

load('ERA5_radiation.mat', 'ERA5_dlwrf_season')
load('ERA5_radiation.mat', 'ERA5_dswrf_season')
load('ERA5_radiation.mat', 'ERA5_lhf_season')
load('ERA5_radiation.mat', 'ERA5_shf_season')
load('ERA5_radiation.mat', 'ERA5_ulwrf_season')
load('ERA5_radiation.mat', 'ERA5_uswrf_season')

ERA5_dlwrf_season_allsky=ERA5_dlwrf_season;
ERA5_dswrf_season_allsky=ERA5_dswrf_season;
ERA5_lhf_season_allsky=ERA5_lhf_season;
ERA5_shf_season_allsky=ERA5_shf_season;
ERA5_ulwrf_season_allsky=ERA5_ulwrf_season;
ERA5_uswrf_season_allsky=ERA5_uswrf_season;

load('ERA5_radiation_clearsky.mat', 'ERA5_dlwrf_season')
load('ERA5_radiation_clearsky.mat', 'ERA5_dswrf_season')
load('ERA5_radiation_clearsky.mat', 'ERA5_lhf_season')
load('ERA5_radiation_clearsky.mat', 'ERA5_shf_season')
load('ERA5_radiation_clearsky.mat', 'ERA5_ulwrf_season')
load('ERA5_radiation_clearsky.mat', 'ERA5_uswrf_season')



figure
[ha, pos] = tight_subplot(2,2,[0.01 0.02],[0.05 0.05],[.13 .13]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf'};
title_name={'JRA55 net shortwave diff','JRA55 net longwave diff','JRA55 net radiation flux diff', 'JRA55 IST bias diff'};
season={'JRA55 no TCC mask','JRA55 with TCC mask','JRA55 mask - no mask'};
text_all={'(a)','(b)','(c)','(d)'};
q=1;
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
        
        m_pcolor(lons,lats,(ERA5_dlwrf_season{1}-ERA5_ulwrf_season{1}) - (ERA5_dlwrf_season_allsky{1}-ERA5_ulwrf_season_allsky{1}));
        
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',60)
        q=q+1;
        %title(title_name{j},'FontSize',18,'Interpreter','none')
        m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
        h=colorbar('eastoutside');
        set(h,'fontsize',18,'tickdir','out','linewidth',1)
        set(get(h,'Title'),'string','W m^-^2')



