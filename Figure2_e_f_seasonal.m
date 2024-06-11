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

%% now show the SEB figures for both ERA5 and JRA55


%% for JRA55

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools
load('lat25.mat')
load('lon25.mat')

load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
% changed to new resampling method

load('JRA55_radiation.mat', 'JRA55_dlwrf_season')
load('JRA55_radiation.mat', 'JRA55_dswrf_season')
load('JRA55_radiation.mat', 'JRA55_lhf_season')
load('JRA55_radiation.mat', 'JRA55_shf_season')
load('JRA55_radiation.mat', 'JRA55_ulwrf_season')
load('JRA55_radiation.mat', 'JRA55_uswrf_season')

JRA55_dlwrf_season_allsky=JRA55_dlwrf_season;
JRA55_dswrf_season_allsky=JRA55_dswrf_season;
JRA55_lhf_season_allsky=JRA55_lhf_season;
JRA55_shf_season_allsky=JRA55_shf_season;
JRA55_ulwrf_season_allsky=JRA55_ulwrf_season;
JRA55_uswrf_season_allsky=JRA55_uswrf_season;

load('JRA55_radiation_clearsky.mat', 'JRA55_dlwrf_season')
load('JRA55_radiation_clearsky.mat', 'JRA55_dswrf_season')
load('JRA55_radiation_clearsky.mat', 'JRA55_lhf_season')
load('JRA55_radiation_clearsky.mat', 'JRA55_shf_season')
load('JRA55_radiation_clearsky.mat', 'JRA55_ulwrf_season')
load('JRA55_radiation_clearsky.mat', 'JRA55_uswrf_season')

for i=1:5
JRA55_ulwrf_season{i}=-JRA55_ulwrf_season{i};
JRA55_uswrf_season{i}=-JRA55_uswrf_season{i};
JRA55_lhf_season{i}=-JRA55_lhf_season{i};
JRA55_shf_season{i}=-JRA55_shf_season{i};

JRA55_ulwrf_season_allsky{i}=-JRA55_ulwrf_season_allsky{i};
JRA55_uswrf_season_allsky{i}=-JRA55_uswrf_season_allsky{i};
JRA55_lhf_season_allsky{i}=-JRA55_lhf_season_allsky{i};
JRA55_shf_season_allsky{i}=-JRA55_shf_season_allsky{i};
end



 %% Figure in SEB section 2
    
    % summer time 2 winter 4
    for i=4 
    load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    JRA55_dlwrf_season_domain=sum(JRA55_dlwrf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dlwrf_season{i})),'all','omitnan');
    JRA55_dswrf_season_domain=sum(JRA55_dswrf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dswrf_season{i})),'all','omitnan');
    JRA55_lhf_season_domain=sum(JRA55_lhf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_lhf_season{i})),'all','omitnan');
    JRA55_shf_season_domain=sum(JRA55_shf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_shf_season{i})),'all','omitnan');
    JRA55_ulwrf_season_domain=sum(JRA55_ulwrf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ulwrf_season{i})),'all','omitnan');
    JRA55_uswrf_season_domain=sum(JRA55_uswrf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_uswrf_season{i})),'all','omitnan');

    JRA55_dlwrf_season_domain_allsky=sum(JRA55_dlwrf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dlwrf_season_allsky{i})),'all','omitnan');
    JRA55_dswrf_season_domain_allsky=sum(JRA55_dswrf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dswrf_season_allsky{i})),'all','omitnan');
    JRA55_lhf_season_domain_allsky=sum(JRA55_lhf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_lhf_season_allsky{i})),'all','omitnan');
    JRA55_shf_season_domain_allsky=sum(JRA55_shf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_shf_season_allsky{i})),'all','omitnan');
    JRA55_ulwrf_season_domain_allsky=sum(JRA55_ulwrf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ulwrf_season_allsky{i})),'all','omitnan');
    JRA55_uswrf_season_domain_allsky=sum(JRA55_uswrf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_uswrf_season_allsky{i})),'all','omitnan');
    end
   

%% for ERA5
cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
% changed to new resampling method

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

for i=1:5
ERA5_ulwrf_season{i}=-ERA5_ulwrf_season{i};
ERA5_uswrf_season{i}=-ERA5_uswrf_season{i};
ERA5_lhf_season{i}=-ERA5_lhf_season{i};
ERA5_shf_season{i}=-ERA5_shf_season{i};

ERA5_ulwrf_season_allsky{i}=-ERA5_ulwrf_season_allsky{i};
ERA5_uswrf_season_allsky{i}=-ERA5_uswrf_season_allsky{i};
ERA5_lhf_season_allsky{i}=-ERA5_lhf_season_allsky{i};
ERA5_shf_season_allsky{i}=-ERA5_shf_season_allsky{i};
end



 %% Figure in SEB section 2

    load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    for i=4  % summer 2 winter 4
    ERA5_dlwrf_season_domain=sum(ERA5_dlwrf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dlwrf_season{i})),'all','omitnan');
    ERA5_dswrf_season_domain=sum(ERA5_dswrf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dswrf_season{i})),'all','omitnan');
    ERA5_lhf_season_domain=sum(ERA5_lhf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_lhf_season{i})),'all','omitnan');
    ERA5_shf_season_domain=sum(ERA5_shf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_shf_season{i})),'all','omitnan');
    ERA5_ulwrf_season_domain=sum(ERA5_ulwrf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ulwrf_season{i})),'all','omitnan');
    ERA5_uswrf_season_domain=sum(ERA5_uswrf_season{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_uswrf_season{i})),'all','omitnan');

    ERA5_dlwrf_season_domain_allsky=sum(ERA5_dlwrf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dlwrf_season_allsky{i})),'all','omitnan');
    ERA5_dswrf_season_domain_allsky=sum(ERA5_dswrf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dswrf_season_allsky{i})),'all','omitnan');
    ERA5_lhf_season_domain_allsky=sum(ERA5_lhf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_lhf_season_allsky{i})),'all','omitnan');
    ERA5_shf_season_domain_allsky=sum(ERA5_shf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_shf_season_allsky{i})),'all','omitnan');
    ERA5_ulwrf_season_domain_allsky=sum(ERA5_ulwrf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ulwrf_season_allsky{i})),'all','omitnan');
    ERA5_uswrf_season_domain_allsky=sum(ERA5_uswrf_season_allsky{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_uswrf_season_allsky{i})),'all','omitnan');
    end
   


    %% now plot the multi-panel figure

text_no1={'(a)','(b)','(c)','(d)','(e)','(f)','(g)'};

figure
set(gcf,'unit','normalized','position',[.1 .08 .6 .85])

data_name={'ERA5', 'JRA55'};


% now plot ERA5 SEB
ax3=axes('position',[0.1 0.1 .33 .60]); % [left bottom width height]
Y=[ERA5_dlwrf_season_domain,ERA5_dlwrf_season_domain_allsky,ERA5_dlwrf_season_domain-ERA5_dlwrf_season_domain_allsky;
       ERA5_ulwrf_season_domain,ERA5_ulwrf_season_domain_allsky,ERA5_ulwrf_season_domain-ERA5_ulwrf_season_domain_allsky;
       ERA5_lhf_season_domain,ERA5_lhf_season_domain_allsky,ERA5_lhf_season_domain-ERA5_lhf_season_domain_allsky;
       ERA5_shf_season_domain,ERA5_shf_season_domain_allsky,ERA5_shf_season_domain-ERA5_shf_season_domain_allsky;
       ERA5_dswrf_season_domain,ERA5_dswrf_season_domain_allsky,ERA5_dswrf_season_domain-ERA5_dswrf_season_domain_allsky;
       ERA5_uswrf_season_domain,ERA5_uswrf_season_domain_allsky,ERA5_uswrf_season_domain-ERA5_uswrf_season_domain_allsky;];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   xlim([-300 300]);
   %yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   %yticklabels({'\textit{L_d}','\textit{S_d}','\textit{F_{lh}}','\textit{F_{hs}}','\textit{L_u}','\textit{S_u}'})
   % 设置 y 轴刻度标签
   yticks = {'L_d','L_u','F_{lh}','F_{hs}','S_d','S_u'};
   set(gca, 'YTickLabel', yticks, 'FontAngle', 'italic');

   xlabel('Surface energy budget (W m^-^2)')
   legend('ERA5 with TCF mask','ERA5 without TCF mask ','With mask - Without mask');
   %legend('clear sky','all sky','clear sky - all sky')
   set(gca,'FontSize',18);
   text(-200,3,'Energy out','FontSize',20)
   text(100,3,'Energy in','FontSize',20)
   
    
    xtips3(1) = b(3).YEndPoints(1) -55;
    xtips3(5) = b(3).YEndPoints(5) + 5;
    xtips3(3) = b(3).YEndPoints(3) + 5;
    xtips3(4) = b(3).YEndPoints(4) + 5;
    xtips3(2) = b(3).YEndPoints(2) + 5;
    xtips3(6) = b(3).YEndPoints(6) - 55;

    ytips3 = b(3).XEndPoints;
    labels3 = string(roundn(b(3).YData,-2));
    text(xtips3,ytips3,labels3,'VerticalAlignment','middle','FontSize',15)

    % now plot the JRA55 SEB
 ax3=axes('position',[0.1+0.16+0.24 0.1 .33 .60]); % [left bottom width height]
Y=[JRA55_dlwrf_season_domain,JRA55_dlwrf_season_domain_allsky,JRA55_dlwrf_season_domain-JRA55_dlwrf_season_domain_allsky;
    JRA55_ulwrf_season_domain,JRA55_ulwrf_season_domain_allsky,JRA55_ulwrf_season_domain-JRA55_ulwrf_season_domain_allsky;       
    JRA55_lhf_season_domain,JRA55_lhf_season_domain_allsky,JRA55_lhf_season_domain-JRA55_lhf_season_domain_allsky;
       JRA55_shf_season_domain,JRA55_shf_season_domain_allsky,JRA55_shf_season_domain-JRA55_shf_season_domain_allsky;
       JRA55_dswrf_season_domain,JRA55_dswrf_season_domain_allsky,JRA55_dswrf_season_domain-JRA55_dswrf_season_domain_allsky;
       JRA55_uswrf_season_domain,JRA55_uswrf_season_domain_allsky,JRA55_uswrf_season_domain-JRA55_uswrf_season_domain_allsky;];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   %yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   %yticklabels({'L_d','S_d','F_{lh}','F_{hs}','L_u','S_u'} )
   % 设置 y 轴刻度标签
   yticks = {'L_d','L_u','F_{lh}','F_{hs}','S_d','S_u'};
   set(gca, 'YTickLabel', yticks, 'FontAngle', 'italic');
   
   xlim([-300 300]);
   xlabel('Surface energy budget (W m^-^2)')
   legend('JRA55 with TCF mask','JRA55 without TCF mask ','With mask - Without mask');
   %legend('clear sky','all sky','clear sky - all sky')
   set(gca,'FontSize',18);
   text(-200,3,'Energy out','FontSize',20)
   text(100,3,'Energy in','FontSize',20)
   
    xtips3(1) = b(3).YEndPoints(1) -45;
    xtips3(5) = b(3).YEndPoints(5) + 5;
    xtips3(3) = b(3).YEndPoints(3) + 5;
    xtips3(4) = b(3).YEndPoints(4) + 5;
    xtips3(2) = b(3).YEndPoints(2) + 5;
    xtips3(6) = b(3).YEndPoints(6) - 55;

    ytips3 = b(3).XEndPoints;
    labels3 = string(roundn(b(3).YData,-2));
    text(xtips3,ytips3,labels3,'VerticalAlignment','middle','FontSize',15)
    
    %manually change the text to the position when want 
    text(0.1, 0.7, '（a）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 18);
    text(0.1, 0.8, '（b）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 18);
