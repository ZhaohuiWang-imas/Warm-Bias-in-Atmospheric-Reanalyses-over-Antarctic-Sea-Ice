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

%now adding JRA3Q
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
   % add cloud mask here
   cloud_JRA3Q=ncread('/Volumes/Postdoc_backup/JRA3Q/JRA3Q_TCC_polargrid.nc','tcdc-tcl-fc-gauss',[1 1 1+24*(i-1)],[Inf Inf 24]);
   cloud_JRA3Q=permute(cloud_JRA3Q,[2 1 3]);
   data_cloud_JRA3Q(:,:,i)=mean(cloud_JRA3Q,3,'omitnan'); 
   i
end


%% check the correlation between CERES and Reanalyses
data_name={'ERA5', 'ERAI', 'MERRA2','NCEPR2', 'JRA55'};
title_name={'ERA5', 'ERA-Interim', 'MERRA2', 'NCEPR2', 'JRA55'};
for type=1:5
for i=1:332
    for j=1:316
      a=permute(data_cloud_CERES(i,j,:),[3 2 1]);
      a1=a(~isnan(a));
      b=permute(eval(['data_cloud_',data_name{type},'(i,j,:)']),[3 2 1]);
      if type ==2
         b1=b(~isnan(a(1:length(b))));
         a1=a1(1:length(b1));
      else
          b1=b(~isnan(a));
      end
                 
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


%%add JRA-3Q
data_name={'ERA5', 'ERAI', 'MERRA2','NCEPR2', 'JRA55','JRA3Q'};
title_name={'ERA5', 'ERA-Interim', 'MERRA-2', 'NCEPR2', 'JRA-55','JRA-3Q'};
for type=6
for i=1:332
    for j=1:316
      a=permute(data_cloud_CERES(i,j,4019:6575),[3 2 1]);
      a1=a(~isnan(a));
      b=permute(eval(['data_cloud_',data_name{type},'(i,j,:)']),[3 2 1]);
      if type ==2
         b1=b(~isnan(a(1:length(b))));
         a1=a1(1:length(b1));
      else
          b1=b(~isnan(a));
      end
                 
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


title_name={'ERA5', 'ERA-Interim', 'MERRA-2', 'NCEPR2', 'JRA-55','JRA-3Q'};
text_no1={'(a)','(b)','(c)','(d)','(e)','(f)','(g)'};

text_all={text_no1};

figure
[ha, pos] = tight_subplot(2,3,[0 0.01],[.1 .1],[.1 .1]);
q=1;

    for j=1:6
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47,'rectbox','on');
        m_contourf(lons,lats,Corr1(:,:,j), -1:0.1:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        hold on
        a=pvalue1(:,:,j);
        m_scatter(lons(a>0.05),lats(a>0.05),0.1,'*','k');
        hold off
        m_gshhs_l('color','k');
        caxis([0 0.8])
        colortable =textread('WhBlGrYeRe.txt');
        colormap(colortable(1:14:100,:));
        %colorbar
        q=q+1;
         title(title_name{j},'FontSize',16)
         m_text(-37,-39,text_all{1}{j},'fontsize',18,'fontname','bold')
    end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Correlation';
set(h,'position',[.925 .25 .01 .5])


%% plot in the manuscript
text_no1={'(a)','(b)','(c)','(d)','(e)','(f)','(g)'};

text_all={text_no1};

figure
[ha, pos] = tight_subplot(2,3,[0 0.01],[.1 .1],[.1 .1]);
q=1;

    for j=1:6
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47,'rectbox','on');
        m_contourf(lons,lats,Corr1(:,:,j), -1:0.1:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        hold on
%         a=pvalue1(:,:,j);
%         m_scatter(lons(a>0.05),lats(a>0.05),0.1,'*','k');
       a=pvalue1(:,:,j);     
      LON=lons(1:10:end,1:10:end);LAT=lats(1:10:end,1:10:end);
      a_reduce=a(1:10:end,1:10:end);
      m_scatter(LON(a_reduce<0.05),LAT(a_reduce<0.05),25,'k','.');
         hold off
        m_gshhs_l('color','k');
        caxis([0 0.8])
        %colortable =textread('WhBlGrYeRe.txt');
        %colormap(colortable(1:14:100,:));
       cmocean('haline',8)
        q=q+1;
         title(title_name{j},'FontSize',16)
         m_text(-37,-39,text_all{1}{j},'fontsize',18,'fontname','bold')
    end


h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Correlation';
set(h,'position',[.925 .25 .01 .5])

save cloud_fraction_corr_CERES_reanalysis Corr1 pvalue1 Neff1
%% plot end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%above are correlatiob based on daily data
%%%%%below are correlation based on monthly data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% 定义日期范围
startDate = datenum('01-Dec-2002');
endDate = datenum('30-Nov-2020');

% 生成日期序列
dateVector = startDate:endDate;

% 假设 daily_data 是一个三维矩阵，其维度分别是经度、纬度和时间
% daily_data = ...; % 你的日数据三维矩阵

% 将日期转换为年份和月份
[yearVec, monthVec, ~] = datevec(dateVector);

% 获取经度和纬度的大小
[nLon, nLat, ~] = size(data_cloud_ERA5);

% 计算总月份数
totalMonths = (max(yearVec) - min(yearVec)) * 12 + (monthVec(end) - monthVec(1) + 1);
totalMonths_ERAI = (max(yearVec(1:6118)) - min(yearVec(1:6118))) * 12 + (monthVec(6118) - monthVec(1) + 1);

% 初始化存储每月平均值的数组
monthlyAverages_ERA5 = zeros(nLon, nLat, totalMonths);
monthlyAverages_CERES = zeros(nLon, nLat, totalMonths);
monthlyAverages_JRA55 = zeros(nLon, nLat, totalMonths);
monthlyAverages_MERRA2 = zeros(nLon, nLat, totalMonths);
monthlyAverages_NCEPR2 = zeros(nLon, nLat, totalMonths);
monthlyAverages_ERAI = zeros(nLon, nLat, totalMonths_ERAI);
% 用于跟踪当前月份的索引
monthIndex = 1;

% 计算每月平均值
for y = min(yearVec):max(yearVec)
    for m = 1:12
        % 确保不超出日期范围
        if y == min(yearVec) && m < monthVec(1)
            continue;
        elseif y == max(yearVec) && m > monthVec(end)
            break;
        end

        % 找出当前年月的所有日数据
        monthData_ERA5 = data_cloud_ERA5(:, :, yearVec == y & monthVec == m);
        monthData_JRA55 = data_cloud_JRA55(:, :, yearVec == y & monthVec == m);
        monthData_CERES = data_cloud_CERES(:, :, yearVec == y & monthVec == m);
        monthData_MERRA2 = data_cloud_MERRA2(:, :, yearVec == y & monthVec == m);
        monthData_NCEPR2 = data_cloud_NCEPR2(:, :, yearVec == y & monthVec == m);
        if monthIndex<=201
        monthData_ERAI = data_cloud_ERAI(:, :, yearVec == y & monthVec == m);
        end
        % 计算平均值 - 对每个经度和纬度点
        monthlyAverages_ERA5(:, :, monthIndex) = mean(monthData_ERA5, 3, 'omitnan');
        monthlyAverages_CERES(:, :, monthIndex) = mean(monthData_CERES, 3, 'omitnan');
        monthlyAverages_JRA55(:, :, monthIndex) = mean(monthData_JRA55, 3, 'omitnan');
        monthlyAverages_MERRA2(:, :, monthIndex) = mean(monthData_MERRA2, 3, 'omitnan');
        monthlyAverages_NCEPR2(:, :, monthIndex) = mean(monthData_NCEPR2, 3, 'omitnan');
        if monthIndex<=201
        monthlyAverages_ERAI(:, :, monthIndex) = mean(monthData_ERAI, 3, 'omitnan');
        end
        % 更新月份索引
        monthIndex = monthIndex + 1;
    end
end

% calculate correlation and P
data_name={'ERA5', 'ERAI', 'MERRA2','NCEPR2', 'JRA55'};
title_name={'ERA5', 'ERA-Interim', 'MERRA2', 'NCEPR2', 'JRA55'};

for type=1:5
for i=1:332
    for j=1:316
      a=permute(monthlyAverages_CERES(i,j,:),[3 2 1]);
      a1=a(~isnan(a));
      b=permute(eval(['monthlyAverages_',data_name{type},'(i,j,:)']),[3 2 1]);
      if type ==2
         b1=b(~isnan(a(1:length(b))));
         a1=a1(1:length(b1));
      else
          b1=b(~isnan(a));
      end
                 
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
    end
    
    Neff2(i,j,type)=adjustedSampleSize;
    Corr2(i,j,type)=r;
    pvalue2(i,j,type)=pValue;
    end
   i
end
end

text_no1={'(a)','(b)','(c)','(d)','(e)','(f)','(g)'};

text_all={text_no1};

figure
[ha, pos] = tight_subplot(1,5,[0 0.01],[.1 .1],[.1 .1]);
q=1;

    for j=1:5
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47,'rectbox','on');
        COE=Corr2(:,:,j);
        a=pvalue2(:,:,j);
%       COE(a>0.05)=nan;
        m_contourf(lons,lats,COE, -1:0.05:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        hold on
        a=pvalue2(:,:,j);
%       [a3 a4]=find(a>0.05);      
%         LAT=[];
%         LONG=[];
%         for i=1:length(a3)
%         LAT(i)=lats(a3(i),a4(i));
%         LONG(i)=lons(a3(i),a4(i));
%         end
      
      LON=lons(1:10:end,1:10:end);LAT=lats(1:10:end,1:10:end);
      a_reduce=a(1:10:end,1:10:end);
      m_scatter(LON(a_reduce<0.05),LAT(a_reduce<0.05),25,'k','.');
        hold off
        m_gshhs_l('color','k');
        caxis([-1 1])
%         colortable =textread('WhBlGrYeRe.txt');
%         colormap(colortable(1:14:100,:));
        %colorbar
        cmocean('balance',40)
        q=q+1;
         title(title_name{j},'FontSize',16)
         m_text(-37,-39,text_all{1}{j},'fontsize',18,'fontname','bold')
    end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Correlation';
set(h,'position',[.925 .25 .01 .5])




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%Put Daily and Monthly correlation together
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


text_no1={'(a)','(b)','(c)','(d)','(e)','(f)','(g)'};

text_all={text_no1};

figure
[ha, pos] = tight_subplot(2,5,[0 0.01],[.1 .1],[.1 .1]);
q=1;

    for j=1:5
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47,'rectbox','on');
        m_contourf(lons,lats,Corr1(:,:,j), -1:0.1:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        hold on
%         a=pvalue1(:,:,j);
%         m_scatter(lons(a>0.05),lats(a>0.05),0.1,'*','k');
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
         title(title_name{j},'FontSize',16)
         m_text(-37,-39,text_all{1}{j},'fontsize',18,'fontname','bold')
    end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Correlation';
set(h,'position',[.92 .525 .01 .35])


text_no2={'(h)','(i)','(j)','(k)','(l)','(m)','(n)'};
text_all={text_no2};
q=6;
    for j=1:5
        axes(ha(q));
        m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47,'rectbox','on');
        m_contourf(lons,lats,Corr2(:,:,j), -1:0.05:1,'LineStyle','None');
        m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
        hold on
        a=pvalue2(:,:,j);     
      LON=lons(1:10:end,1:10:end);LAT=lats(1:10:end,1:10:end);
      a_reduce=a(1:10:end,1:10:end);
      m_scatter(LON(a_reduce<0.05),LAT(a_reduce<0.05),25,'k','.');
        hold off
        m_gshhs_l('color','k');
        caxis([-1 1])
        cmocean('balance',40)
        q=q+1;
         %title(title_name{j},'FontSize',16)
         m_text(-37,-39,text_all{1}{j},'fontsize',18,'fontname','bold')
    end

h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Correlation';
set(h,'position',[.92 .125 .01 .35])
