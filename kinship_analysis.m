clc
clear all
close all

load channeling_events

% Loading data from the dynamic table into regular vectors
gotchis = channelingevents.Gotchi_id;
parcels = channelingevents.Realm_id;
FUD = channelingevents.FUD;
FOMO = channelingevents.FOMO;
ALPHA = channelingevents.ALPHA;
KEK = channelingevents.KEK;
spillover = channelingevents.spilloverRate/10000;

% Getting day of each channeling event
blockDateTime = char(channelingevents.evt_block_time);
blockDate = string(blockDateTime(:,1:10));

% Calculating kinship based on the amount of FUD produced per channeling
kinship = 50*(FUD/(20)).^2;

% RF Leaderboard Cut-off Kinship @ 09/02/2023
kinshipCutoff(100)  = 1452;
kinshipCutoff(500)  = 1401;
kinshipCutoff(1000) = 1341;
kinshipCutoff(2000) = 1184;
kinshipCutoff(3000) = 1101;
kinshipCutoff(4000) = 1070;
kinshipCutoff(5000) = 1038;

% Evaluating data, calculating events per day contained in the snapshot
figure('Color','white')
histogram(datetime(blockDate))
ylabel('# channelings analysed')
grid on

%% Analysing data of a single day

% User input
selectedDay = '2023-02-05';

% Selecting active indices and calculating histogram
selectedRange = (blockDate == selectedDay);
selectedFUD =FUD(selectedRange);
selectedKinship = kinship(selectedRange);
[sortedKinship,rankingIndices] = sort(selectedKinship,'descend');
[nGotchis, xAxis] = hist(selectedKinship,0:25:1700);

%%
% Plotting results of overall population based on kinship and rank
figure('Position',[680   558   988   420]),
bar(xAxis, nGotchis)
hold on
xline(kinshipCutoff(100),'g','TOP100');
xline(kinshipCutoff(500),'m','TOP500');
xline(kinshipCutoff(1000),'r','TOP1K');
xline(kinshipCutoff(2000),'b','TOP2K');
xline(kinshipCutoff(5000),'c','TOP5K');
xlabel('Kinship')
ylabel('#gotchis')
ylim([0 1000])
grid on

figure('Position',[681    48   985   420])
plot(xAxis,cumsum(nGotchis,'reverse'))
hold on
xline(kinshipCutoff(100),'g','TOP100');
xline(kinshipCutoff(500),'m','TOP500');
xline(kinshipCutoff(1000),'r','TOP1K');
xline(kinshipCutoff(2000),'b','TOP2K');
xline(kinshipCutoff(5000),'c','TOP5K');
xlabel('Kinship')
ylabel('cumulative #gotchis')

%% Evolution of daily FUD emission
timeAxis = 1:365;
kinshipBurn = [0 1 2 3 4];
kinshipEvolution = zeros(length(selectedKinship),length(timeAxis),length(kinshipBurn));
noChannelingCuttoff = 500;
noChannelingGotchis = rankingIndices(1:noChannelingCuttoff);
channelingGotchis = rankingIndices(noChannelingCuttoff+1:end);

% No burn
for j = 1 : length(timeAxis)
    kinshipEvolution(:,j,1) = selectedKinship + 2*timeAxis(j);
end

% Burning Kinship Simulation
for k = 2 : length(kinshipBurn)
    for j = 1 : length(timeAxis)
        kinshipEvolution(channelingGotchis,j,k) = selectedKinship(channelingGotchis) + (2-kinshipBurn(k))*timeAxis(j);
        kinshipEvolution(noChannelingGotchis,j,k) = selectedKinship(noChannelingGotchis) + 2*timeAxis(j);
    end
end

% Removing negative kinship
kinshipEvolution(kinshipEvolution<0)=0;

referenceFUDEmission = sum( 20*sqrt(selectedKinship/50) );
FUDEvolution = squeeze(sum( 20*sqrt(kinshipEvolution(channelingGotchis,:,:)/50) , 1));
% Recalculating current with all gotchis channeling
FUDEvolution(:,1) = squeeze(sum( 20*sqrt(kinshipEvolution(:,:,1)/50) , 1));


figure('Color','white','Position',[ 354   458   886   520]),
plot(timeAxis,(FUDEvolution/referenceFUDEmission-1)*100)
%plot(timeAxis,(FUDEvolution)*100)
grid on
legend('Current','-1 KIN','-2 KIN','-3 KIN','-4 KIN','location','SouthWest')
xlabel('Days')
ylabel('Daily FUD Emission (%)')
title(['Channeling emission assuming top ' num2str(noChannelingCuttoff) ' gotchis stop channeling'])
xlim([0 365])

