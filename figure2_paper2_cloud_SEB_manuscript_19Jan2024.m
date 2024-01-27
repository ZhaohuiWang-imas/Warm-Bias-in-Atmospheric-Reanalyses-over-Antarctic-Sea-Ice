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

cd /Users/zhaohuiw/Desktop/Onedrive_backup/PHD_Thesis/figures_code/paper2
load Figure16_paper2_corr_CERES_TCF *_ME_masked


text_no1={'(a)','(b)','(c)','(d)','(e)','(f)','(g)'};

text_all={text_no1};


figure
%title_name={'May', 'Jun','Jul','Aug','Sep','Oct'};
data_name={'ERA5', 'MERRA2', 'ERAI', 'NCEPR2', 'JRA55'};
[ha, pos] = tight_subplot(1,5,[0 0],[.1 .1],[.1 .1]);
%season={'ALL','JFM','AMJ','JAS','OND'};
q=1;
for j=1:5
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
        m_contourf(lons,lats,eval([data_name{j},'_ME_masked{1}']), 0:0.05:1,'LineStyle','None');
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
        m_text(-43,-45,text_all{1}{j},'fontsize',18,'fontname','bold')
end


h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Cloud fraction';
set(h,'position',[.925 .25 .01 .5])



%% cloud correlation with CERES


%% we also compare the annual mean of CEARES, ERA5, JRA55 using the hourly data
% for i=1:length(x0)
%    % CERES
%    
%    cloud_CERES=ncread('/Volumes/ExtremePro/WANG_SSD/CERES/cloud_fraction/CERES_cloud_all_polargrid.nc','cldarea_total_1h',[1 1 8017+24*(i-1)],[Inf Inf 24]);
%    cloud_CERES=permute(cloud_CERES,[2 1 3]);
%    data_cloud_CERES(:,:,i)=mean(cloud_CERES,3,'omitnan'); 
%    
%    % ERA5
%    
%    cloud_ERA5=ncread('/Volumes/ExtremePro/WANG_SSD/ERA5_cloud/ERA5_cloudcover_all_polargrid.nc','var164',[1 1 8017+24*(i-1)],[Inf Inf 24]);
%    cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
%    data_cloud_ERA5(:,:,i)=mean(cloud_ERA5,3,'omitnan'); 
% 
%    % JRA55
%    
%    cloud_JRA55=ncread('/Volumes/ExtremePro/WANG_SSD/JRA55_cloud/JRA55_cloud_merge_polargrid.nc','TCDC_GDS4_ISBY',[1 1 2673+8*(i-1)],[Inf Inf 8]);
%    cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
%    data_cloud_JRA55(:,:,i)=mean(cloud_JRA55,3,'omitnan'); 
%    i
% end
% 
% cd /Volumes/ExtremePro
% save data_cloud_reanalysis_CERES data_cloud_*  -v7.3
%% check the correlation between CERES and Reanalyses

cd /Volumes/ExtremePro
load data_cloud_reanalysis_CERES data_cloud_ERA5 data_cloud_JRA55 data_cloud_CERES


data_name={'ERA5', 'JRA55'};

for type=1:2
for i=1:332
    for j=1:316
      a=permute(data_cloud_CERES(i,j,:),[3 2 1]);
      a1=a(~isnan(a));
      b=permute(eval(['data_cloud_',data_name{type},'(i,j,:)']),[3 2 1]);
      b1=b(~isnan(a));
      
      [R,~] = corrcoef(b1,a1); 
      r=R(1,2); % this is the corr coef
      
      % calculating p value considering the autocorrelation
        if ~isnan(b1)
        n = length(b1);
        autocorr1 = autocorr(a1, 1);
        autocorr2 = autocorr(b1, 1);
        adjustedSampleSize = n * (1 - autocorr1(2) * autocorr2(2)) / (1 + autocorr1(2) * autocorr2(2));
        % 计算 t 统计量
        t = r * sqrt((adjustedSampleSize - 2) / (1 - r^2));
        % 计算 P 值
        pValue = 2 * (1 - tcdf(abs(t), adjustedSampleSize - 2));
        else
        pValue=nan;
        adjustedSampleSize=nan;
        end
    
    Neff1(i,j,type)=adjustedSampleSize;
    Corr1(i,j,type)=r;
    pvalue1(i,j,type)=pValue;
    end
   i
end
end

text_no1={'(a)','(b)','(c)','(d)','(e)','(f)','(g)'};

text_all={text_no1};

figure
[ha, pos] = tight_subplot(1,2,[0 0.01],[.1 .1],[.1 .1]);
q=1;

    for j=1:2
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47,'rectbox','on');
        m_contourf(lons,lats,Corr1(:,:,j), -1:0.1:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        hold on
        a=pvalue1(:,:,j);
        LON=lons(1:10:end,1:10:end);LAT=lats(1:10:end,1:10:end);
        a_reduce=a(1:10:end,1:10:end);
        m_scatter(LON(a_reduce<0.05),LAT(a_reduce<0.05),25,'k','.');
        hold off
        m_gshhs_l('color','k');
        caxis([0 0.8])
        colortable =textread('WhBlGrYeRe.txt');
        colormap(colortable(1:14:100,:));
        %colorbar
        q=q+1;
         title(data_name{j},'FontSize',16)
         m_text(-37,-39,text_all{1}{j},'fontsize',18,'fontname','bold')
    end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Correlation';
set(h,'position',[.925 .25 .01 .5])


%% now show the SEB figures for both ERA5 and JRA55


%% for JRA55

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools
load('lat25.mat')
load('lon25.mat')

load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';

cd /Volumes/ExtremePro/Extreme_SSD/radiation_output

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

    load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
    JRA55_dlwrf_season_domain=sum(JRA55_dlwrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dlwrf_season{1})),'all','omitnan');
    JRA55_dswrf_season_domain=sum(JRA55_dswrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dswrf_season{1})),'all','omitnan');
    JRA55_lhf_season_domain=sum(JRA55_lhf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_lhf_season{1})),'all','omitnan');
    JRA55_shf_season_domain=sum(JRA55_shf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_shf_season{1})),'all','omitnan');
    JRA55_ulwrf_season_domain=sum(JRA55_ulwrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ulwrf_season{1})),'all','omitnan');
    JRA55_uswrf_season_domain=sum(JRA55_uswrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_uswrf_season{1})),'all','omitnan');

    JRA55_dlwrf_season_domain_allsky=sum(JRA55_dlwrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dlwrf_season_allsky{1})),'all','omitnan');
    JRA55_dswrf_season_domain_allsky=sum(JRA55_dswrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_dswrf_season_allsky{1})),'all','omitnan');
    JRA55_lhf_season_domain_allsky=sum(JRA55_lhf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_lhf_season_allsky{1})),'all','omitnan');
    JRA55_shf_season_domain_allsky=sum(JRA55_shf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_shf_season_allsky{1})),'all','omitnan');
    JRA55_ulwrf_season_domain_allsky=sum(JRA55_ulwrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ulwrf_season_allsky{1})),'all','omitnan');
    JRA55_uswrf_season_domain_allsky=sum(JRA55_uswrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_uswrf_season_allsky{1})),'all','omitnan');

   figure
   
   Y=[JRA55_dlwrf_season_domain,JRA55_dlwrf_season_domain_allsky,JRA55_dlwrf_season_domain-JRA55_dlwrf_season_domain_allsky;
       JRA55_dswrf_season_domain,JRA55_dswrf_season_domain_allsky,JRA55_dswrf_season_domain-JRA55_dswrf_season_domain_allsky;
       JRA55_lhf_season_domain,JRA55_lhf_season_domain_allsky,JRA55_lhf_season_domain-JRA55_lhf_season_domain_allsky;
       JRA55_shf_season_domain,JRA55_shf_season_domain_allsky,JRA55_shf_season_domain-JRA55_shf_season_domain_allsky;
       JRA55_ulwrf_season_domain,JRA55_ulwrf_season_domain_allsky,JRA55_ulwrf_season_domain-JRA55_ulwrf_season_domain_allsky;
       JRA55_uswrf_season_domain,JRA55_uswrf_season_domain_allsky,JRA55_uswrf_season_domain-JRA55_uswrf_season_domain_allsky;];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   xlabel('Surface energy budget (W m^-^2)')
   legend('JRA55 with TCF mask','JRA55 without TCF mask ','With mask - Without mask');
   %legend('clear sky','all sky','clear sky - all sky')
   set(gca,'FontSize',18);
   text(-200,3,'Energy out','FontSize',20)
   text(100,3,'Energy in','FontSize',20)
   
    
    xtips3(1) = b(3).YEndPoints(1) -50;
    xtips3(2) = b(3).YEndPoints(2) + 5;
    xtips3(3) = b(3).YEndPoints(3) + 5;
    xtips3(4) = b(3).YEndPoints(4) + 5;
    xtips3(5) = b(3).YEndPoints(5) + 5;
    xtips3(6) = b(3).YEndPoints(6) - 50;

    ytips3 = b(3).XEndPoints;
    labels3 = string(roundn(b(3).YData,-2));
    text(xtips3,ytips3,labels3,'VerticalAlignment','middle','FontSize',15)


%% for ERA5
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
    ERA5_dlwrf_season_domain=sum(ERA5_dlwrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dlwrf_season{1})),'all','omitnan');
    ERA5_dswrf_season_domain=sum(ERA5_dswrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dswrf_season{1})),'all','omitnan');
    ERA5_lhf_season_domain=sum(ERA5_lhf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_lhf_season{1})),'all','omitnan');
    ERA5_shf_season_domain=sum(ERA5_shf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_shf_season{1})),'all','omitnan');
    ERA5_ulwrf_season_domain=sum(ERA5_ulwrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ulwrf_season{1})),'all','omitnan');
    ERA5_uswrf_season_domain=sum(ERA5_uswrf_season{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_uswrf_season{1})),'all','omitnan');

    ERA5_dlwrf_season_domain_allsky=sum(ERA5_dlwrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dlwrf_season_allsky{1})),'all','omitnan');
    ERA5_dswrf_season_domain_allsky=sum(ERA5_dswrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_dswrf_season_allsky{1})),'all','omitnan');
    ERA5_lhf_season_domain_allsky=sum(ERA5_lhf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_lhf_season_allsky{1})),'all','omitnan');
    ERA5_shf_season_domain_allsky=sum(ERA5_shf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_shf_season_allsky{1})),'all','omitnan');
    ERA5_ulwrf_season_domain_allsky=sum(ERA5_ulwrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ulwrf_season_allsky{1})),'all','omitnan');
    ERA5_uswrf_season_domain_allsky=sum(ERA5_uswrf_season_allsky{1}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_uswrf_season_allsky{1})),'all','omitnan');

   figure
   
   Y=[ERA5_dlwrf_season_domain,ERA5_dlwrf_season_domain_allsky,ERA5_dlwrf_season_domain-ERA5_dlwrf_season_domain_allsky;
       ERA5_dswrf_season_domain,ERA5_dswrf_season_domain_allsky,ERA5_dswrf_season_domain-ERA5_dswrf_season_domain_allsky;
       ERA5_lhf_season_domain,ERA5_lhf_season_domain_allsky,ERA5_lhf_season_domain-ERA5_lhf_season_domain_allsky;
       ERA5_shf_season_domain,ERA5_shf_season_domain_allsky,ERA5_shf_season_domain-ERA5_shf_season_domain_allsky;
       ERA5_ulwrf_season_domain,ERA5_ulwrf_season_domain_allsky,ERA5_ulwrf_season_domain-ERA5_ulwrf_season_domain_allsky;
       ERA5_uswrf_season_domain,ERA5_uswrf_season_domain_allsky,ERA5_uswrf_season_domain-ERA5_uswrf_season_domain_allsky;];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   xlabel('Surface energy budget (W m^-^2)')
   legend('ERA5 with TCF mask','ERA5 without TCF mask ','With mask - Without mask');
   %legend('clear sky','all sky','clear sky - all sky')
   set(gca,'FontSize',18);
   text(-200,3,'Energy out','FontSize',20)
   text(100,3,'Energy in','FontSize',20)
   
    
    xtips3(1) = b(3).YEndPoints(1) -50;
    xtips3(2) = b(3).YEndPoints(2) + 5;
    xtips3(3) = b(3).YEndPoints(3) + 5;
    xtips3(4) = b(3).YEndPoints(4) + 5;
    xtips3(5) = b(3).YEndPoints(5) + 5;
    xtips3(6) = b(3).YEndPoints(6) - 50;

    ytips3 = b(3).XEndPoints;
    labels3 = string(roundn(b(3).YData,-2));
    text(xtips3,ytips3,labels3,'VerticalAlignment','middle','FontSize',15)



    %% now plot the multi-panel figure

text_no1={'(a)','(b)','(c)','(d)','(e)','(f)','(g)'};

figure
set(gcf,'unit','normalized','position',[.1 .08 .6 .85])

data_name={'ERA5', 'JRA55'};

% first plot the cloud fraction
ax1=axes('position',[0.1 0.75 .15 .20]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_contourf(lons,lats,eval([data_name{1},'_ME_masked{1}']), 0:0.05:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([0 1])
colortable =textread('WhBlGrYeRe.txt');
colormap(ax1,colortable(1:5:end,:));
 title(data_name{1},'FontSize',16,'Interpreter','none')     
%         if j==1
%          ylabel(data_name{1},'FontSize',16,'fontweight','bold')
%         end
m_text(-37,-39,text_no1{1},'fontsize',18,'fontname','bold')

ax1=axes('position',[0.1+0.16 0.75 .15 .20]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_contourf(lons,lats,eval([data_name{2},'_ME_masked{1}']), 0:0.05:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([0 1])
colortable =textread('WhBlGrYeRe.txt');
colormap(ax1,colortable(1:5:end,:));
 title(data_name{2},'FontSize',16,'Interpreter','none')     
%         if j==1
%          ylabel(data_name{1},'FontSize',16,'fontweight','bold')
%         end
m_text(-37,-39,text_no1{2},'fontsize',18,'fontname','bold')

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Cloud fraction';
set(h,'position',[.42 .76 .01 .18])

% then plot the cloud correlation

ax2=axes('position',[0.1+0.16+0.24 0.75 .15 .20]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47,'rectbox','on');
m_contourf(lons,lats,Corr1(:,:,1), -1:0.1:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
hold on
a=pvalue1(:,:,1);
LON=lons(1:10:end,1:10:end);LAT=lats(1:10:end,1:10:end);
a_reduce=a(1:10:end,1:10:end);
m_scatter(LON(a_reduce<0.05),LAT(a_reduce<0.05),25,'k','.');
hold off
m_gshhs_l('color','k');
caxis([0 0.8])
colortable =textread('WhBlGrYeRe.txt');
colormap(ax2,colortable(1:14:100,:));
title(data_name{1},'FontSize',16)
m_text(-37,-39,text_no1{3},'fontsize',18,'fontname','bold')

ax2=axes('position',[0.1+0.16+0.24+0.16 0.75 .15 .20]); % [left bottom width height]
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47,'rectbox','on');
m_contourf(lons,lats,Corr1(:,:,2), -1:0.1:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
hold on
a=pvalue1(:,:,2);
LON=lons(1:10:end,1:10:end);LAT=lats(1:10:end,1:10:end); % adjust stippling density
a_reduce=a(1:10:end,1:10:end); % adjust stippling density
m_scatter(LON(a_reduce<0.05),LAT(a_reduce<0.05),25,'k','.');
hold off
m_gshhs_l('color','k');
caxis([0 0.8])
colortable =textread('WhBlGrYeRe.txt');
colormap(ax2,colortable(1:14:100,:));
title(data_name{2},'FontSize',16)
m_text(-37,-39,text_no1{4},'fontsize',18,'fontname','bold')

h1=colorbar('eastoutside');
set(h1,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h1.Label.String = 'Correlation';
set(h1,'position',[.82 .76 .01 .18])

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
    text(0.1, 0.7, '（e）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 18);
    text(0.1, 0.8, '（f）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 18);
