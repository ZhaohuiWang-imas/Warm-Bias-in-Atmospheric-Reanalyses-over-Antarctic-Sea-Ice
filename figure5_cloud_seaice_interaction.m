%%The figure has several part

%%Top two bar figure shows (a) cloud bias in each cloud level
%%(b) IST bias reduction after apply each level of cloud fraction mask
%%(c) cloud formation in four experiment with seasonal varying
%%(d) wintertime SEB between Quasi-ERA5 and Quasi-JRA55
%%(e) probably plot the downward longwave

%% analysis for figure (b)

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


%LCF
cd /Volumes/ExtremePro/MODIS_gauss/
load data_ME_02cloud_LCF_gauss17km.mat data_ME* 
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME_LCF{j}=ERA5_ME_season;
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_LCF{j}=JRA3Q_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME_LCF{j}=JRA55_ME_season;
end

%MCF
cd /Volumes/ExtremePro/MODIS_gauss/
load data_ME_02cloud_MCF_gauss17km.mat data_ME* 
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME_MCF{j}=ERA5_ME_season;
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_MCF{j}=JRA3Q_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME_MCF{j}=JRA55_ME_season;
end

%HCF
cd /Volumes/ExtremePro/MODIS_gauss/
load data_ME_02cloud_HCF_gauss17km.mat data_ME* 
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,X{j}),3);
ERA5_ME_HCF{j}=ERA5_ME_season;
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_HCF{j}=JRA3Q_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,X{j}),3);
JRA55_ME_HCF{j}=JRA55_ME_season;
end

%TCF
cd /Volumes/ExtremePro/MODIS_gauss
load data_ME_02cloud_gauss17km.mat data_ME* 

clear dates datestr datevec
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);
x0=(1:length(datevec(4019:end,:)))';
[x1,]=find(datevec(4019:end,2)==3 | datevec(4019:end,2)==1 | datevec(4019:end,2)==2);
[x2,]=find(datevec(4019:end,2)==6 | datevec(4019:end,2)==4 | datevec(4019:end,2)==5);
[x3,]=find(datevec(4019:end,2)==9 | datevec(4019:end,2)==7 | datevec(4019:end,2)==8);
[x4,]=find(datevec(4019:end,2)==12 | datevec(4019:end,2)==10 | datevec(4019:end,2)==11);
X={x0,x1,x2,x3,x4};
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,4018+X{j}),3);
ERA5_ME_TCF{j}=ERA5_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,4018+X{j}),3);
JRA55_ME_TCF{j}=JRA55_ME_season;
end
clear dates datestr datevec


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
cd /Volumes/ExtremePro/MODIS_gauss
load data_ME_02cloud_gauss17km_JRA3Q.mat
for j=1:5
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_TCF{j}=JRA3Q_ME_season;
end

%No cloud fraction mask
cd /Volumes/ExtremePro/MODIS_gauss
load data_ME_gauss17km.mat data_ME* 

clear dates datestr datevec
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);
x0=(1:length(datevec(4019:end,:)))';
[x1,]=find(datevec(4019:end,2)==3 | datevec(4019:end,2)==1 | datevec(4019:end,2)==2);
[x2,]=find(datevec(4019:end,2)==6 | datevec(4019:end,2)==4 | datevec(4019:end,2)==5);
[x3,]=find(datevec(4019:end,2)==9 | datevec(4019:end,2)==7 | datevec(4019:end,2)==8);
[x4,]=find(datevec(4019:end,2)==12 | datevec(4019:end,2)==10 | datevec(4019:end,2)==11);
X={x0,x1,x2,x3,x4};
for j=1:5
ERA5_ME_season=nanmean(data_ME_ERA5(:,:,4018+X{j}),3);
ERA5_ME_NCF{j}=ERA5_ME_season;
JRA55_ME_season=nanmean(data_ME_JRA55(:,:,4018+X{j}),3);
JRA55_ME_NCF{j}=JRA55_ME_season;
end
clear dates datestr datevec


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
cd /Volumes/ExtremePro/MODIS_gauss
load data_ME_gauss17km_JRA3Q.mat
for j=1:5
JRA3Q_ME_season=nanmean(data_ME_JRA3Q(:,:,X{j}),3);
JRA3Q_ME_NCF{j}=JRA3Q_ME_season;
end



load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')


for i=1:5
    load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
  
    JRA3Q_ME_NCF_domain{i}=sum(JRA3Q_ME_NCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA3Q_ME_NCF{i})),'all','omitnan');
    JRA3Q_ME_LCF_domain{i}=sum(JRA3Q_ME_LCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA3Q_ME_LCF{i})),'all','omitnan');
    JRA3Q_ME_MCF_domain{i}=sum(JRA3Q_ME_MCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA3Q_ME_MCF{i})),'all','omitnan');
    JRA3Q_ME_HCF_domain{i}=sum(JRA3Q_ME_HCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA3Q_ME_HCF{i})),'all','omitnan');
    JRA3Q_ME_TCF_domain{i}=sum(JRA3Q_ME_TCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA3Q_ME_TCF{i})),'all','omitnan');

    JRA55_ME_NCF_domain{i}=sum(JRA55_ME_NCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ME_NCF{i})),'all','omitnan');
    JRA55_ME_LCF_domain{i}=sum(JRA55_ME_LCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ME_LCF{i})),'all','omitnan');
    JRA55_ME_MCF_domain{i}=sum(JRA55_ME_MCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ME_MCF{i})),'all','omitnan');
    JRA55_ME_HCF_domain{i}=sum(JRA55_ME_HCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ME_HCF{i})),'all','omitnan');
    JRA55_ME_TCF_domain{i}=sum(JRA55_ME_TCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(JRA55_ME_TCF{i})),'all','omitnan');


    ERA5_ME_NCF_domain{i}=sum(ERA5_ME_NCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ME_NCF{i})),'all','omitnan');
    ERA5_ME_LCF_domain{i}=sum(ERA5_ME_LCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ME_LCF{i})),'all','omitnan');
    ERA5_ME_MCF_domain{i}=sum(ERA5_ME_MCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ME_MCF{i})),'all','omitnan');
    ERA5_ME_HCF_domain{i}=sum(ERA5_ME_HCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ME_HCF{i})),'all','omitnan');
    ERA5_ME_TCF_domain{i}=sum(ERA5_ME_TCF{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(ERA5_ME_TCF{i})),'all','omitnan');

end



for i=1;
ERA5_bias_cloud_level=[ERA5_ME_NCF_domain{i},ERA5_ME_HCF_domain{i},ERA5_ME_MCF_domain{i},ERA5_ME_LCF_domain{i},ERA5_ME_TCF_domain{i}];
JRA55_bias_cloud_level=[JRA55_ME_NCF_domain{i},JRA55_ME_HCF_domain{i},JRA55_ME_MCF_domain{i},JRA55_ME_LCF_domain{i},JRA55_ME_TCF_domain{i}];
JRA3Q_bias_cloud_level=[JRA3Q_ME_NCF_domain{i},JRA3Q_ME_HCF_domain{i},JRA3Q_ME_MCF_domain{i},JRA3Q_ME_LCF_domain{i},JRA3Q_ME_TCF_domain{i}];
end

figure
y=[ERA5_bias_cloud_level; JRA3Q_bias_cloud_level; JRA55_bias_cloud_level;];
x=categorical({'ERA5','JRA3Q','JRA55'});
x=reordercats(x,{'ERA5','JRA3Q','JRA55'});
bar(x,y)
ylim([-4.5 8]);
set(gca,'FontSize',20);
ylabel('Bias (K)','FontSize',20)
legend('No CF','HCF','MCF','LCF','TCF')

%% analysis for figure (a)

clear dates datestr datevec x* X
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


cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools
load('lon25.mat')
load('lat25.mat')

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
load cloud_fra_clear_sky_JRA55_HML cloud_JRA55_*_masked
load cloud_fra_clear_sky_ERA5_HML cloud_ERA5_*_masked
load cloud_fra_clear_sky_JRA3Q_HML cloud_JRA3Q_*_masked



load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')


for i=1:5
    load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
    area_nasa=area_nasa';
  
    
    JRA3Q_LCF_domain{i}=sum(cloud_JRA3Q_LCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_JRA3Q_LCF_masked{i})),'all','omitnan');
    JRA3Q_MCF_domain{i}=sum(cloud_JRA3Q_MCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_JRA3Q_MCF_masked{i})),'all','omitnan');
    JRA3Q_HCF_domain{i}=sum(cloud_JRA3Q_HCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_JRA3Q_HCF_masked{i})),'all','omitnan');
    JRA3Q_TCF_domain{i}=sum(cloud_JRA3Q_TCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_JRA3Q_TCF_masked{i})),'all','omitnan');

    
    JRA55_LCF_domain{i}=sum(cloud_JRA55_LCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_JRA55_LCF_masked{i})),'all','omitnan');
    JRA55_MCF_domain{i}=sum(cloud_JRA55_MCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_JRA55_MCF_masked{i})),'all','omitnan');
    JRA55_HCF_domain{i}=sum(cloud_JRA55_HCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_JRA55_HCF_masked{i})),'all','omitnan');
    JRA55_TCF_domain{i}=sum(cloud_JRA55_TCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_JRA55_TCF_masked{i})),'all','omitnan');


    
    ERA5_LCF_domain{i}=sum(cloud_ERA5_LCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_ERA5_LCF_masked{i})),'all','omitnan');
    ERA5_MCF_domain{i}=sum(cloud_ERA5_MCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_ERA5_MCF_masked{i})),'all','omitnan');
    ERA5_HCF_domain{i}=sum(cloud_ERA5_HCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_ERA5_HCF_masked{i})),'all','omitnan');
    ERA5_TCF_domain{i}=sum(cloud_ERA5_TCF_masked{i}.*area_nasa,'all','omitnan')./sum(area_nasa(~isnan(cloud_ERA5_TCF_masked{i})),'all','omitnan');

end


for i=1;
ERA5_cloud_level=[ERA5_HCF_domain{i},ERA5_MCF_domain{i},ERA5_LCF_domain{i},ERA5_TCF_domain{i}];
JRA55_cloud_level=[JRA55_HCF_domain{i},JRA55_MCF_domain{i},JRA55_LCF_domain{i},JRA55_TCF_domain{i}];
JRA3Q_cloud_level=[JRA3Q_HCF_domain{i},JRA3Q_MCF_domain{i},JRA3Q_LCF_domain{i},JRA3Q_TCF_domain{i}];
end

figure
y=[ERA5_cloud_level; JRA3Q_cloud_level; JRA55_cloud_level;];
x=categorical({'ERA5','JRA3Q','JRA55'});
x=reordercats(x,{'ERA5','JRA3Q','JRA55'});
bar(x,y)
ylim([0 1]);
set(gca,'FontSize',20);
ylabel('Cloud fraction bias under clear sky','FontSize',20)
legend('HCF','MCF','LCF','TCF')



%%(c) cloud formation in four experiment with seasonal varying
clear dates datestr datevec x* X
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

% % extract the cloud data
% data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_bin_polargrid.nc','CFRACT');
% TCC_nosnow_2m_bin=permute(data,[2 1 3]);
% data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_2m_fra_polargrid.nc','CFRACT');
% TCC_nosnow_2m_fra=permute(data,[2 1 3]);
% data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_nosnow_15m_frac_polargrid.nc','CFRACT');
% TCC_nosnow_15m_fra=permute(data,[2 1 3]);
% data=ncread('/Volumes/PostDoc_drive/WRF_run_4_exp/WRF_var_SIT_15m_SNOW_5_frac_polargrid.nc','CFRACT');
% TCC_SIT_15m_SNOW_5_frac=permute(data,[2 1 3]);
% 
% 
% cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools
% 
% load('lon25.mat')
% load('lat25.mat')
% 
% %Annual seasonal mean cloud fraction difference
% 
% for i=1:length(x0)
%    TCC_nosnow_2m_bin_per_day=TCC_nosnow_2m_bin(:,:,(i-1)*24+1:i*24);
%    TCC_nosnow_2m_bin_daily(:,:,i)=mean((TCC_nosnow_2m_bin_per_day),3,'omitnan'); 
% 
%    TCC_nosnow_2m_fra_per_day=TCC_nosnow_2m_fra(:,:,(i-1)*24+1:i*24);
%    TCC_nosnow_2m_fra_daily(:,:,i)=mean((TCC_nosnow_2m_fra_per_day),3,'omitnan'); 
% 
%    TCC_nosnow_15m_fra_per_day=TCC_nosnow_15m_fra(:,:,(i-1)*24+1:i*24);
%    TCC_nosnow_15m_fra_daily(:,:,i)=mean((TCC_nosnow_15m_fra_per_day),3,'omitnan'); 
% 
%    TCC_SIT_15m_SNOW_5_frac_per_day=TCC_SIT_15m_SNOW_5_frac(:,:,(i-1)*24+1:i*24);
%    TCC_SIT_15m_SNOW_5_fra_daily(:,:,i)=mean((TCC_SIT_15m_SNOW_5_frac_per_day),3,'omitnan'); 
% end
% 
% 
% for j=1:5
% TCC_nosnow_2m_bin_season{j}=mean(TCC_nosnow_2m_bin_daily(:,:,X{j}),3,'omitnan');
% TCC_nosnow_2m_fra_season{j}=mean(TCC_nosnow_2m_fra_daily(:,:,X{j}),3,'omitnan');
% TCC_nosnow_15m_fra_season{j}=mean(TCC_nosnow_15m_fra_daily(:,:,X{j}),3,'omitnan');
% TCC_SIT_15m_SNOW_5_fra_season{j}=mean(TCC_SIT_15m_SNOW_5_fra_daily(:,:,X{j}),3,'omitnan');
% end
cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
%save TCC_four_exp TCC_nosnow_2m_bin_season TCC_nosnow_2m_fra_season TCC_nosnow_15m_fra_season TCC_SIT_15m_SNOW_5_fra_season
load TCC_four_exp


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


h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
h.Label.String = 'Seasonal mean cloud fraction difference';
set(h,'position',[.72 .23 .01 .5])




%%d) wintertime SEB between Quasi-ERA5 and Quasi-JRA55

cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
load Quasi_JRA55_ERA5_SEB data_*_season_domain 

figure
i=4;
Y=[data_LWDNB_ERA5_15_season_domain{i},data_LWDNB_ERA5_20_season_domain{i},data_LWDNB_ERA5_15_season_domain{i}-data_LWDNB_ERA5_20_season_domain{i};
-data_LWUPB_ERA5_15_season_domain{i},-data_LWUPB_ERA5_20_season_domain{i},-data_LWUPB_ERA5_15_season_domain{i}+data_LWUPB_ERA5_20_season_domain{i};       
-data_LH_ERA5_15_season_domain{i},-data_LH_ERA5_20_season_domain{i},-data_LH_ERA5_15_season_domain{i}+data_LH_ERA5_20_season_domain{i};
-data_HFX_ERA5_15_season_domain{i},-data_HFX_ERA5_20_season_domain{i},-data_HFX_ERA5_15_season_domain{i}+data_HFX_ERA5_20_season_domain{i};
data_SWDNB_ERA5_15_season_domain{i},data_SWDNB_ERA5_20_season_domain{i},data_SWDNB_ERA5_15_season_domain{i}-data_SWDNB_ERA5_20_season_domain{i};
-data_SWUPB_ERA5_15_season_domain{i},-data_SWUPB_ERA5_20_season_domain{i},-data_SWUPB_ERA5_15_season_domain{i}+data_SWUPB_ERA5_20_season_domain{i};];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   %yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   %yticklabels({'L_d','S_d','F_{lh}','F_{hs}','L_u','S_u'} )
   % 设置 y 轴刻度标签
   yticks = {'L_d','L_u','F_{lh}','F_{sh}','S_d','S_u'};
   set(gca, 'YTickLabel', yticks, 'FontAngle', 'italic');
   
   xlim([-300 300]);
   xlabel('Surface energy budget (W m^-^2)')
   legend('Quasi-ERA5','Quasi-JRA55 ','Quasi-ERA5 - Quasi-JRA55');
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
    %text(0.1, 0.8, '（f）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 18);









 %% Now we working for form a Whole figure



figure
set(gcf,'unit','normalized','position',[.1 .08 .65 .85])

data_name={'ERA5', 'JRA55'};

ax1=axes('position',[0.08 0.70 .4 .25]); % [left bottom width height]
y=[ERA5_cloud_level; JRA3Q_cloud_level; JRA55_cloud_level;];
x=categorical({'ERA5','JRA3Q','JRA55'});
x=reordercats(x,{'ERA5','JRA3Q','JRA55'});
bar(x,y)
ylim([0 1]);
set(gca,'FontSize',20);
ylabel('Cloud fraction bias under clear sky','FontSize',20)
legend('HCF','MCF','LCF','TCF')


ax2=axes('position',[0.57 0.70 .4 .25]); % [left bottom width height]
y=[ERA5_bias_cloud_level; JRA3Q_bias_cloud_level; JRA55_bias_cloud_level;];
x=categorical({'ERA5','JRA3Q','JRA55'});
x=reordercats(x,{'ERA5','JRA3Q','JRA55'});
b=bar(x,y);
b(5).FaceColor = [.1 .4 .5];
ylim([-4.5 8]);
set(gca,'FontSize',20);
ylabel('Bias (K)','FontSize',20)
legend('No CF','HCF','MCF','LCF','TCF')


text_no1={'(c1)','(c2)','(c3)'};
text_no2={'(d1)','(d2)','(d3)'};
text_no3={'(e1)','(e2)','(e3)'};
text_no4={'(j)','(k)','(l)'};
text_no5={'(m)','(n)','(o)'};


data_name={'nosnow_15m_fra','nosnow_2m_fra','SIT_15m_SNOW_5_fra'};
title_name={'Quasi-ERA5 - Quasi-JRA55','Exp-SIT - Quasi-JRA55', 'Exp-SNOW - Quasi-JRA55'};
season={'ALL','JFM','AMJ','JAS','OND'};

for i=1:3
    for j=1
ax3=axes('position',[0.04+0.14*(i-1) 0.43-0.18*(j-1) .18 .16]); % [left bottom width height]
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
title(title_name{i},'FontSize',12)
end
if i==1
ylabel(season{j},'FontSize',16)
end

    end
m_text(-45,-45,text_no1{i},'fontsize',25,'fontname','bold')
end

for i=1:3
    for j=2
ax4=axes('position',[0.04+0.14*(i-1) 0.43-0.18*(j-1) .18 .16]); % [left bottom width height]
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
ylabel(season{j},'FontSize',16)
end

    end
m_text(-45,-45,text_no2{i},'fontsize',25,'fontname','bold')
end


for i=1:3
    for j=3
ax5=axes('position',[0.04+0.14*(i-1) 0.43-0.18*(j-1) .18 .16]); % [left bottom width height]
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
ylabel('JAS','FontSize',16)
end

    end
m_text(-45,-45,text_no3{i},'fontsize',25,'fontname','bold')
end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%h.Label.String = 'Mean cloud fraction difference';
set(h,'position',[.49 .13 .01 .4])

ax6=axes('position',[0.565 0.07 .38 .55]); % [left bottom width height]
i=4;
Y=[data_LWDNB_ERA5_15_season_domain{i},data_LWDNB_ERA5_20_season_domain{i},data_LWDNB_ERA5_15_season_domain{i}-data_LWDNB_ERA5_20_season_domain{i};
-data_LWUPB_ERA5_15_season_domain{i},-data_LWUPB_ERA5_20_season_domain{i},-data_LWUPB_ERA5_15_season_domain{i}+data_LWUPB_ERA5_20_season_domain{i};       
-data_LH_ERA5_15_season_domain{i},-data_LH_ERA5_20_season_domain{i},-data_LH_ERA5_15_season_domain{i}+data_LH_ERA5_20_season_domain{i};
-data_HFX_ERA5_15_season_domain{i},-data_HFX_ERA5_20_season_domain{i},-data_HFX_ERA5_15_season_domain{i}+data_HFX_ERA5_20_season_domain{i};
data_SWDNB_ERA5_15_season_domain{i},data_SWDNB_ERA5_20_season_domain{i},data_SWDNB_ERA5_15_season_domain{i}-data_SWDNB_ERA5_20_season_domain{i};
-data_SWUPB_ERA5_15_season_domain{i},-data_SWUPB_ERA5_20_season_domain{i},-data_SWUPB_ERA5_15_season_domain{i}+data_SWUPB_ERA5_20_season_domain{i};];
   b=barh(Y);
   yticks([1,2,3,4,5,6])
   %yticklabels({'dlwrf','dswrf','lhf','shf','ulwrf','uswrf'})
   %yticklabels({'L_d','S_d','F_{lh}','F_{hs}','L_u','S_u'} )
   % 设置 y 轴刻度标签
   yticks = {'L_d','L_u','F_{lh}','F_{sh}','S_d','S_u'};
   set(gca, 'YTickLabel', yticks, 'FontAngle', 'italic','YAxisLocation', 'right');
   xlim([-300 300]);
   xlabel('Surface energy budget (W m^-^2)')
   legend('Quasi-ERA5','Quasi-JRA55 ','Quasi-ERA5 - Quasi-JRA55');
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
    text(0.1, 0.7, '（a）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 24);
    text(0.1, 0.8, '（b）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 24);
  text(0.1, 0.9, '（f）', 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 24);