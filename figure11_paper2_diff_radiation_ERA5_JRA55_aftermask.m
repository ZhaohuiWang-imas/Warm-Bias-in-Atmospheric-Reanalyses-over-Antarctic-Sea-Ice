
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



figure
[ha, pos] = tight_subplot(2,2,[0.01 0.02],[0.05 0.05],[.13 .13]);
data_name={'dswrf', 'uswrf','dlwrf','ulwrf'};
title_name={'Net shortwave diff','Net longwave diff','Net radiation flux diff', 'Net turbulent flux diff'};
season={'ERA5','JRA55','JRA55 - ERA5'};
text_all={'(a)','(b)','(c)','(d)'};
q=1;
    for j=1:4
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
        if j==3
        m_pcolor(lons,lats,(JRA55_uswrf_season{1}+JRA55_ulwrf_season{1}-JRA55_dswrf_season{1}-JRA55_dlwrf_season{1})-(ERA5_uswrf_season{1}+ERA5_ulwrf_season{1}-ERA5_dswrf_season{1}-ERA5_dlwrf_season{1}));
        elseif j==4
        m_pcolor(lons,lats,(JRA55_lhf_season{1}+JRA55_shf_season{1})-(ERA5_lhf_season{1}+ERA5_shf_season{1})); 
        else
        m_pcolor(lons,lats,eval(['JRA55_',data_name{2*j},'_season{1}','-','JRA55_',data_name{2*j-1},'_season{1}','-','ERA5_',data_name{2*j},'_season{1}','+','ERA5_',data_name{2*j-1},'_season{1}']));
        end
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        m_gshhs_l('color','k');
        caxis([-50 50])
        cmocean('balance',600)
        q=q+1;
        title(title_name{j},'FontSize',18,'Interpreter','none')
        m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
        h=colorbar('eastoutside');
        set(h,'fontsize',18,'tickdir','out','linewidth',1)
        set(get(h,'Title'),'string','W m^-^2')
    end