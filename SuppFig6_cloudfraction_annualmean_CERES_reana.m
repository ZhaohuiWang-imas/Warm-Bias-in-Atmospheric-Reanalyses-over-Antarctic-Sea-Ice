% this program is used for investigate the influence of cloud on IST biases
% in each reanalyses

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


load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')








%% we also compare the annual mean of CEARES, ERA5, JRA55 using the hourly data

for i=1:length(x0)
   % CERES
   % add cloud mask here
   cloud_CERES=ncread('/Volumes/ExtremePro/WANG_SSD/CERES/cloud_fraction/CERES_cloud_all_polargrid.nc','cldarea_total_1h',[1 1 8017+24*(i-1)],[Inf Inf 24]);
   cloud_CERES=permute(cloud_CERES,[2 1 3]);
   data_cloud_CERES(:,:,i)=mean(cloud_CERES,3,'omitnan'); 
   
   % ERA5
   % add cloud mask here
   cloud_ERA5=ncread('/Volumes/ExtremePro/WANG_SSD/ERA5_cloud/ERA5_cloudcover_all_polargrid.nc','var164',[1 1 8017+24*(i-1)],[Inf Inf 24]);
   cloud_ERA5=permute(cloud_ERA5,[2 1 3]);
   data_cloud_ERA5(:,:,i)=mean(cloud_ERA5,3,'omitnan'); 
   % MERRA2
   % add cloud mask here
   cloud_MERRA2=ncread('/Volumes/ExtremePro/WANG_SSD/MERRA2_cloud/MERRA2_cloudcover_all_polargrid.nc','CLDTOT',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_MERRA2=permute(cloud_MERRA2,[2 1 3]);
   data_cloud_MERRA2(:,:,i)=mean(cloud_MERRA2,3,'omitnan'); 
   % JRA55
   % add cloud mask here
   cloud_JRA55=ncread('/Volumes/ExtremePro/WANG_SSD/JRA55_cloud/JRA55_cloud_merge_polargrid.nc','TCDC_GDS4_ISBY',[1 1 2673+8*(i-1)],[Inf Inf 8]);
   cloud_JRA55=permute(cloud_JRA55,[2 1 3]);
   data_cloud_JRA55(:,:,i)=mean(cloud_JRA55,3,'omitnan'); 
   % NCEPR2
   % add cloud mask here
   cloud_NCEPR2=ncread('/Volumes/ExtremePro/WANG_SSD/NCEPR2_cloud/NCEPR2_cloud_merge_polargrid.nc','tcdc',[1 1 1337+4*(i-1)],[Inf Inf 4]);
   cloud_NCEPR2=permute(cloud_NCEPR2,[2 1 3]);
   data_cloud_NCEPR2(:,:,i)=mean(cloud_NCEPR2,3,'omitnan'); 
   %ERA-I
   if i<=6118
   cloud_ERAI=ncread('/Volumes/ExtremePro/WANG_SSD/ERAI_cloud/ERAI_cloudcover_all_polargrid.nc','tcc',[1 1 1337+4*(i-1)],[Inf Inf 4]);
   cloud_ERAI=permute(cloud_ERAI,[2 1 3]);
   data_cloud_ERAI(:,:,i)=mean(cloud_ERAI,3,'omitnan'); 
   end
   i
end



%seasonal cloud (masked without model)
CERES_ME_season=mean(data_cloud_CERES,3,'omitnan')./100;
ERA5_ME_season=mean(data_cloud_ERA5,3,'omitnan');
JRA55_ME_season=mean(data_cloud_JRA55,3,'omitnan')./100;
MERRA2_ME_season=mean(data_cloud_MERRA2,3,'omitnan');
NCEPR2_ME_season=mean(data_cloud_NCEPR2,3,'omitnan')./100;
ERAI_ME_season=mean(data_cloud_ERAI,3,'omitnan');


%% now considering JRA-3Q

clear dates datestr datevec
%date of each experiment
dates = [datenum('01-Dec-2013'):datenum('30-Nov-2020')];
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
   % add JRA3Q
   cloud_JRA3Q=ncread('/Volumes/Postdoc_backup/JRA3Q/JRA3Q_TCC_polargrid.nc','tcdc-tcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_JRA3Q=permute(cloud_JRA3Q,[2 1 3]);
   data_cloud_JRA3Q(:,:,i)=mean(cloud_JRA3Q,3,'omitnan'); 
   
   % add CERES
   cloud_CERES=ncread('/Volumes/ExtremePro/WANG_SSD/CERES/cloud_fraction/CERES_cloud_all_polargrid.nc','cldarea_total_1h',[1 1 104449+24*(i-1)],[Inf Inf 24]);
   cloud_CERES=permute(cloud_CERES,[2 1 3]);
   data_cloud_CERES_for_3Q(:,:,i)=mean(cloud_CERES,3,'omitnan'); 
   i
end

CERES_3Q_ME_season=mean(data_cloud_CERES_for_3Q,3,'omitnan')./100;
JRA3Q_ME_season=mean(data_cloud_JRA3Q,3,'omitnan')./100;


%% JRA3Q end


figure
[ha, pos] = tight_subplot(2,3,[.01 .01],[.01 .04],[.03 .03]);
data_name={'JRA3Q','ERA5','ERAI','MERRA2','JRA55','NCEPR2'};
q=1;
for i=1
    for j=1:6
        axes(ha(q));
        m_proj('stereographic','lat',-90,'lon',0,'radius',40);
        m_contourf(lons,lats,eval([data_name{j},'_ME_season']), 0:0.05:1,'LineStyle','None');
        m_grid('ytick',8,'xtick',12,'xaxislocation','top');
        %m_gshhs_l('color','k');
        caxis([0 1])
        colortable =textread('WhBlGrYeRe.txt');
        colormap(colortable(1:5:end,:));
        colorbar
        q=q+1;
        hold on
        %m_contour(lons,lats,seaice_conc_cdr_climitology{i},[0.8 0.8],'red','LineWidth',2);
        hold off
       
         title(data_name{j},'FontSize',16)
        
        
    end
end

text_all={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
data_name={'ERA5','ERAI','MERRA2','JRA55','NCEPR2','JRA3Q'};
title_name={'ERA5','ERA-Interim','MERRA-2','JRA-55','NCEPR2','JRA-3Q'};

figure
[ha, pos] = tight_subplot(2,3,[.01 .015],[.01 .04],[.03 .1]);
%[ha, pos] = tight_subplot(2, 3, [.03 .015], [.05 .04], [.03 .1]);


for j=1:5
axes(ha(j));
m_proj('azimuthal equal-area','latitude',-90,'longitude',0,'radius',47.9,'rectbox','on');
m_contourf(lons,lats,eval([data_name{j},'_ME_season - CERES_ME_season']), -1:0.05:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
m_gshhs_i('patch', [0.8 0.8 0.8]);
caxis([-0.4 0.4])
% colortable =textread('WhBlGrYeRe.txt');
% colormap(colortable(1:5:end,:));
cmocean('balance',16)
title(title_name{j},'FontSize',18)
m_text(-45,-45,text_all{j},'fontsize',22,'fontname','bold')
end

for j=6
axes(ha(j));
m_proj('azimuthal equal-area','latitude',-90,'longitude',0,'radius',47.9,'rectbox','on');
m_contourf(lons,lats,eval([data_name{j},'_ME_season - CERES_3Q_ME_season']), -1:0.05:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
m_gshhs_i('patch', [0.8 0.8 0.8]);
caxis([-0.4 0.4])
% colortable =textread('WhBlGrYeRe.txt');
% colormap(colortable(1:5:end,:));
cmocean('balance',16)
title(title_name{j},'FontSize',18)
m_text(-45,-45,text_all{j},'fontsize',22,'fontname','bold')
end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','Cloud fraction')
h.Label.String = 'Cloud fraction difference';
set(h,'position',[.925 .25 .01 .5])

