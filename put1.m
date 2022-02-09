clear all,clc,close all
tic
load('OptionData.mat')
Capital=1000000;
y1=0.014;%平仓iv差
y2=0.028;%开仓iv差
date1=2; %平仓天数;
date2=7;%开仓天数
k1=0.002;%平仓止损
k2=0.005;%开仓止损

%%
result={'策略年化收益','基准收益','Beta','Alpha','波动率','夏普比','最大回撤','单次最大收益','单次最大损失','胜率',' 盈亏比','平均收益','平均损失','交易次数','平均每次交易盈利','平均每次交易亏损','平均每次交易资金占用'};rr=2;
timelist={'2015/01/01','2015/12/31';'2016/01/01','2016/12/31';'2017/01/01','2017/12/31';'2018/01/01','2018/12/31';'2019/01/01','2019/06/28'};
time={'date','当日盈亏','总盈亏','收益率','code','组合数量','净值','资金占用','rfree','基准收益','基准收益率','基准净值','净值差比率'};
list={'A code','B code','详细信息','当日盈亏','资金占用'};
detail_use={'日期','exe_price A','maint_margin A','ptmtradeday A','iv A','A仓位','A收盘价','exe_price B','maint_margin B','ptmtradeday B','iv B','B仓位','B收盘价','A资金占用','B资金占用','A当日盈亏','B当日盈亏','A delta','B delta','当日总盈亏'};
chart={'开仓日期','平仓日期','A 行权价','IV A','A仓位','B 行权价','IV B','B仓位','总盈亏','平均资金占用','总仓位','持仓天数','收益率','年化收益率','开仓IV差','平仓IV差','平仓剩余天数'};
mm=1;
    for i=2:size(OptionData,1)
          time{i,1}=OptionData{i,1};  
          time{i,2}=0;
          time{i,8}=0;
          k=OptionData{i,4};
          data=OptionData{i,3};
        %当第一天时，没有情况发生，判断日期是否是第一天，若不是，则写入数据    
            if i~=2
                code=time{i-1,5};        
            else
                code=list;
            end
        %平仓模块：将新的代码与原来的代码进行对比，若有相同的代码，则判断是否该持仓
            for a=size(code,1):-1:2
                detail=code{a,3};
                nn=size(detail,1)+1;
                detail{nn,1}=OptionData{i,1};
                for c=2:size(data,1)            
                    if strcmp(code{a,1},data{c,1})                
                        detail{nn,2}=data{c,3};
                        detail{nn,3}=data{c,4};
                        detail{nn,4}=data{c,5};
                        detail{nn,5}=data{c,12};  
                        detail{nn,6}=detail{nn-1,6};  
                        detail{nn,7}=data{c,17}; 
                        detail{nn,18}=data{c,6};                 
                    end            
                    if strcmp(code{a,2},data{c,1})               
                        detail{nn,8}=data{c,3};
                        detail{nn,9}=data{c,4};
                        detail{nn,10}=data{c,5};
                        detail{nn,11}=data{c,12};  
                        detail{nn,12}=detail{nn-1,12}; 
                        detail{nn,13}=data{c,17};
                        detail{nn,19}=data{c,6};                    
                    end
                end
            %平仓操作：如果组代码的隐波差值小于给定系数，则需平仓，如果不是，则持仓，并计算当日盈亏
                if  abs(detail{nn,11}-detail{nn,5})<=y1 || detail{nn,4}<=date1 ||(strcmp(detail{nn,20},OptionData{1,3})&&detail{nn,8}>=k-k1)
                        detail{nn,16}=(detail{nn,7}-detail{nn-1,7})*detail{nn,6}*10000-detail{nn,6}*2;
                        detail{nn,17}=(detail{nn,13}-detail{nn-1,13})*detail{nn,12}*10000*-1-detail{nn,12}*2;
                        detail{nn,14}=detail{nn,6}*detail{nn,7}*10000;
                        detail{nn,15}=detail{nn,12}*detail{nn,9};
                        detail{nn,20}=detail{nn,16}+detail{nn,17};
                        code{a,4}=detail{nn,16}+detail{nn,17};
                        time{i,2}=time{i,2}+code{a,4};
                        mm=mm+1;
                        chart{mm,1}=detail{2,1};
                        chart{mm,2}=detail{end,1};
                        chart{mm,3}=detail{nn,2};
                        chart{mm,4}=detail{2,5};
                        chart{mm,5}=detail{nn,6};
                        chart{mm,6}=detail{nn,8};
                        chart{mm,7}=detail{nn,11};
                        chart{mm,8}=detail{nn,12};
                        chart{mm,9}=sum(cell2mat(detail(2:end,20)));
                        chart{mm,10}=mean(detail{nn,14})+mean(detail{nn,15});
                        chart{mm,11}=detail{nn,6}+detail{nn,12};
                        chart{mm,12}=detail{2,10}-detail{end,10};
                        chart{mm,13}=chart{mm,9}/chart{mm,10};
                        chart{mm,14}=chart{mm,13}*chart{mm,12}/250;
                        chart{mm,15}=abs(detail{2,5}-detail{2,11});
                        chart{mm,16}=abs(detail{end,5}-detail{end,11});
                        chart{mm,17}=detail{end,4};
                        code(a,:)=[];
                else  %hold 持仓操作
                        detail{nn,16}=(detail{nn,7}-detail{nn-1,7})*detail{nn,6}*10000;
                        detail{nn,17}=(detail{nn,13}-detail{nn-1,13})*detail{nn,12}*10000*-1;
                        detail{nn,14}=detail{nn,6}*detail{nn,7}*10000;
                        detail{nn,15}=detail{nn,12}*detail{nn,9};
                        detail{nn,20}=detail{nn,16}+detail{nn,17};
                        code{a,4}=detail{nn,16}+detail{nn,17}; 
                        code{a,5}=detail{nn,14}+detail{nn,15};
                        code{a,3}=detail;                    
                end
            end
            time{i,5}=code;            
            %开仓模块：根据给定隐波差值，找出符合条件的近月认购期权组
            data=OptionData{i,3};
            a=unique(cell2mat(data(2:end,5)));
            for g=1:length(a)
                if a(g)>=10
                    t=a(g);
                    break
                end
            end
            for q=2:size(data,1) 
                s=data{q,3};
                x=abs(s-k);
                if k<=3
                    sk=0.025;
                else
                    sk=0.05;
                end  
                if x<=sk && data{q,5}==t
                    v0=data{q,12};
                    L1=q;       
                    break
                end
            end            
            for q2=size(data,1):-1:3
                if data{q2,5}==t && data{q2-1,5}~=t
                    L2=q2;
                    break
                end
                if q2==3
                    L2=2;
                end
            end 
            jj=size(code,1);
            for h=L1:-1:L2+1
                for j=h-1:-1:L2
                    x=abs(data{h,12}-data{j,12});        
                    if x>=y2 && data{j,17}>=k2
                        flag=0;
                        for kkk=2:size(code,1) 
                            if strcmp(code{kkk,1},data{j,1}) && strcmp(code{kkk,2},data{h,1})
                                flag=1;
                                break
                            end
                        end
                    %判断改组认购期权是否已经储存在以前的组合中，若存在，则持仓，若不存在，则开仓        
                        if flag==0  
                            jj=jj+1;
                            code{jj,1}=data{h,1};
                            code{jj,2}=data{j,1};
                            nn=2;
                            detail=detail_use;
                            detail{nn,1}=OptionData{i,1};
                            for d=2:size(data,1)                                        
                                if strcmp(code{jj,1},data{d,1})                
                                        detail{nn,2}=data{d,3};
                                        detail{nn,3}=data{d,4};
                                        detail{nn,4}=data{d,5};
                                        detail{nn,5}=data{d,12};                            
                                        detail{nn,7}=data{d,17};
                                        detail{nn,18}=data{d,6};
                                end
                                    if strcmp(code{jj,2},data{d,1})
                                        detail{nn,8}=data{d,3};
                                        detail{nn,9}=data{d,4};
                                        detail{nn,10}=data{d,5};
                                        detail{nn,11}=data{d,12};       
                                        detail{nn,13}=data{d,17};
                                        detail{nn,19}=data{d,6};
                                    end                                            
                            end
                        end
                            B=round(Capital/(detail{nn,9}+detail{nn,13}*10000));
                            A=round(detail{nn,13}*B/detail{nn,7});
                            detail{nn,6}=A;
                            detail{nn,12}=B;
                            detail{nn,14}=detail{nn,6}*detail{nn,7}*10000;
                            detail{nn,15}=detail{nn,12}*detail{nn,9};
                            detail{nn,16}=(detail{nn,7}-detail{nn,7})*detail{nn,6}*10000-detail{nn,6}*2;
                            detail{nn,17}=(detail{nn,13}-detail{nn,13})*detail{nn,12}*10000*-1;
                            detail{nn,20}=detail{nn,16}+detail{nn,17};
                            code{jj,3}=detail;
                            code{jj,4}=detail{nn,16}+detail{nn,17};
                            code{jj,5}=detail{nn,14}+detail{nn,15};
                     end
                 end
            end
        time{i,2}=sum(cell2mat(code(2:end,4)));
        if i~=2
            time{i,3}=time{i,2}+time{i-1,3};
        else
            time{i,3}=time{i,2};
        end
        time{i,8}=sum(cell2mat(code(2:end,5)));
        if time{i,8}~=0
            time{i,4}=time{i,2}/time{i,8};
        else
            time{i,4}=0;
        end
        time{i,6}=size(code,1)-1;
        if i~=2
            time{i,7}=(time{i,4}+1)*time{i-1,7};
        else
            time{i,7}=1*(time{i,4}+1);
        end
        time{i,9}=OptionData{i,5};
        if i~=2 
            time{i,10}=OptionData{i,4}*OptionData{i,6}-OptionData{i-1,4}*OptionData{i-1,6};
            time{i,11}=(OptionData{i,4}*OptionData{i,6}-OptionData{i-1,4}*OptionData{i-1,6})/(OptionData{i-1,4}*OptionData{i-1,6});
        else
            time{i,10}=0;
            time{i,11}=0;
        end
        if i~=2
            time{i,12}=(time{i,11}+1)*time{i-1,12};
        else
            time{i,12}=1*(time{i,11}+1);
        end
        if i~=2
            time{i,13}=(time{i,7}-time{i-1,7})/time{i-1,7};
        else
            time{i,13}=0;
        end     
        time{i,5}=code;
        disp(OptionData{i,1})
        toc
    end
        
    %%%%
    result{rr,1} = (time{end,7}/time{2,7}-1)*250/size(time,1);
    result{rr,2}=(time{end,12}/time{2,12}-1)*250/size(time,1) ;
    Be=cov(cell2mat(time(2:end,4)),cell2mat(time(2:end,11)))/std(cell2mat(time(2:end,11)));
    result{rr,3}=Be(2,1);
    rf=sum(cell2mat(time(2:end,9)))/(size(time,1)*100);
    result{rr,4}=result{rr,1}-rf-result{rr,3}*(result{rr,2}-rf);
    result{rr,5}=std(cell2mat(time(2:end,4)))*sqrt(250);
    result{rr,6}=( result{rr,1}- rf)/result{rr,5};
    result{rr,7}=maxdrawdown(cell2mat(time(2:end,7)));
    result{rr,8}=max(cell2mat(chart(2:end,9)));
    result{rr,9}=min(cell2mat(chart(2:end,9)));
    w=0;
    for o=2:size(chart,1)
        if chart{o,9}>=0
            w=w+1;
        end
    end
    result{rr,10}=w/(size(chart,1)-1);
    e=0;
    SS=sort(cell2mat(chart(2:end,9)));
    for Q=2:size(SS,1)
        if SS(Q,1)<=0
            e=e+1;
        end
            loss=sum(SS(1:e,1)); 
            earning=sum(SS(e+1:end,1));
            
    end
    result{rr,12}=earning/size(chart(2:end,9),1);
    result{rr,13}=loss/size(chart(2:end,9),1);
    result{rr,11}=abs(earning/loss);
    result{rr,14}=size(chart,1);
    result{rr,15}=earning/size(SS(e+1:end,1),1);
    result{rr,16}=loss/size(SS(1:e,1),1);
    result{rr,17}=sum(cell2mat(chart(2:end,10)))/size(chart,1);




%% 
%1.分年度
%2.参数稳健性检验和优化




              

