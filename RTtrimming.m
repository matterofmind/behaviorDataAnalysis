%%% RTtrimming.m
% code started: Jane 20180802 Thu 20:01
% last edit: Jane 20180816 Thu 14:45
% from RT1
% I want average of the Correct & Inlier
% for every condition: Car/Face/My * Control/Target

numIteration = 12;
%12 hits the maximum plateau for every subject in this case
whatSD = 2.5;
trimIter = struct();
%% Reaction time Trimming
for iIter = 1:numIteration
    %% extract only those index I want
    trimIter(iIter).trimRT = struct;
    for iSub = 1:25 %25 is the total number of subject
        %% need only correct ones for the average calculation
        % make incorrect RTs into zero
        % load raw data
        trimIter(iIter).trimRT(iSub).Acc = sum(Data(iSub).Acc)/480; % accuracy 
        trimIter(iIter).trimRT(iSub).AngAcc = sum(Data(iSub).Aacc)/480; % Angle accuracy
        trimIter(iIter).trimRT(iSub).PosAcc = sum(Data(iSub).Pacc)/480; % Position accuracy
        trimIter(iIter).trimRT(iSub).RT1 = Data(iSub).RT1480; %reset the RT set same as the raw data
        trimIter(iIter).trimRT(iSub).RT1Correct = Data(iSub).RT1480; %reset the RT set same as the raw data
        
        trimIter(iIter).trimRT(iSub).iAcc = Data(iSub).Acc; %correct index        
        trimIter(iIter).trimRT(iSub).RT1Correct(find(~trimIter(iIter).trimRT(iSub).iAcc(:))) = 0; %incorret RTs to zero
        nonzeroRT1 = find(trimIter(iIter).trimRT(iSub).RT1Correct);        
        
        %% need only non Outliers (and correct ones)
        % for iIter==1, make only nonzeroRT1 group
        trimIter(iIter).trimRT(iSub).nonzeroRT1=trimIter(iIter).trimRT(iSub).RT1Correct(nonzeroRT1);
        % outlier calculation
        if iIter ==1            
            % get mean, std prior to get the outliers
            trimIter(iIter).trimRT(iSub).threshold(1) = mean(trimIter(iIter).trimRT(iSub).nonzeroRT1(:));  %mean
            trimIter(iIter).trimRT(iSub).threshold(2) = std(trimIter(iIter).trimRT(iSub).nonzeroRT1(:));   %std
            %Data(iSub).stat.RT1(3) = isoutlier(Data(iSub).RT1,'mean'); %3std
            %MATLAB2018
        else % iteration get the mean / std from before 
            % get NEW mean, std prior to get the outliers
            trimIter(iIter).trimRT(iSub).threshold(1) = trimIter(iIter-1).trimRT(iSub).threshold(3);  %new mean
            trimIter(iIter).trimRT(iSub).threshold(2) = trimIter(iIter-1).trimRT(iSub).threshold(4);  %new std
            %Data(iSub).stat.RT1(3) = isoutlier(Data(iSub).RT1,'mean'); %3std
            %MATLAB2018
        end
        RT1mean=trimIter(iIter).trimRT(iSub).threshold(1); %shortcut
        RT1std=whatSD*trimIter(iIter).trimRT(iSub).threshold(2); %shortcut
        % indexing inliesrs(logic of inlier =1 , outlier = 0)
        trimIter(iIter).trimRT(iSub).outCut = [RT1mean-RT1std,RT1mean+RT1std];
        outCut=trimIter(iIter).trimRT(iSub).outCut; %shortcut
        % outlier from BOTH correct and incorrect
        trimIter(iIter).trimRT(iSub).InOut{1}= [Data(iSub).RT1480>outCut(1)];
        trimIter(iIter).trimRT(iSub).InOut{2}= [Data(iSub).RT1480<outCut(2)];
        trimIter(iIter).trimRT(iSub).InOut{3}= [trimIter(iIter).trimRT(iSub).InOut{1}...
            &trimIter(iIter).trimRT(iSub).InOut{2}];
        
        % outlier RT collection and categorization
        trimIter(iIter).trimRT(iSub).iOut = (find(trimIter(iIter).trimRT(iSub).InOut{3}==0)); %outlier index
        % trimIter(iIter).trimRT(iSub).iOut is a outlier index 
        % that includes BOTH incorrect and correct outliers
        trimIter(iIter).trimRT(iSub).OutRT1 =Data(iSub).RT1480(trimIter(iIter).trimRT(iSub).iOut); %outlier RT1s
        trimIter(iIter).trimRT(iSub).outlierPers = ...
            Data(iSub).Condition(trimIter(iIter).trimRT(iSub).iOut(:)); %outlier perspective mark
        trimIter(iIter).trimRT(iSub).outlierOri = ...
            Data(iSub).Atarg(trimIter(iIter).trimRT(iSub).iOut(:)); %outlier orientation mark
        
        % outliers condition categorizing--------------------------------------
        trimIter(iIter).trimRT(iSub).Out_TC_CFM=cell(6,1);
        for iOut = 1:length(trimIter(iIter).trimRT(iSub).iOut)
            thisOutlierCond = trimIter(iIter).trimRT(iSub).outlierOri(iOut);
            if thisOutlierCond==2||thisOutlierCond==8
                switch trimIter(iIter).trimRT(iSub).outlierPers(iOut)
                    case 0 %car
                        trimIter(iIter).trimRT(iSub).Out_TC_CFM{1} = ...
                            [trimIter(iIter).trimRT(iSub).Out_TC_CFM{1}(:); ...
                            trimIter(iIter).trimRT(iSub).RT1( trimIter(iIter).trimRT(iSub).iOut(iOut) )];
                    case 1 %face
                        trimIter(iIter).trimRT(iSub).Out_TC_CFM{2} = ...
                            [trimIter(iIter).trimRT(iSub).Out_TC_CFM{2}(:); ...
                            trimIter(iIter).trimRT(iSub).RT1( trimIter(iIter).trimRT(iSub).iOut(iOut) )];
                    case 3 %my
                        trimIter(iIter).trimRT(iSub).Out_TC_CFM{3} = ...
                            [trimIter(iIter).trimRT(iSub).Out_TC_CFM{3}(:); ...
                            trimIter(iIter).trimRT(iSub).RT1( trimIter(iIter).trimRT(iSub).iOut(iOut) )];
                end
            else
                switch trimIter(iIter).trimRT(iSub).outlierPers(iOut)
                    case 0 %car
                        trimIter(iIter).trimRT(iSub).Out_TC_CFM{4} = ...
                            [trimIter(iIter).trimRT(iSub).Out_TC_CFM{4}(:); ...
                            trimIter(iIter).trimRT(iSub).RT1( trimIter(iIter).trimRT(iSub).iOut(iOut) )];
                    case 1 %face
                        trimIter(iIter).trimRT(iSub).Out_TC_CFM{5} = ...
                            [trimIter(iIter).trimRT(iSub).Out_TC_CFM{5}(:); ...
                            trimIter(iIter).trimRT(iSub).RT1( trimIter(iIter).trimRT(iSub).iOut(iOut) )];
                    case 3 %my
                        trimIter(iIter).trimRT(iSub).Out_TC_CFM{6} = ...
                            [trimIter(iIter).trimRT(iSub).Out_TC_CFM{6}(:); ...
                            trimIter(iIter).trimRT(iSub).RT1( trimIter(iIter).trimRT(iSub).iOut(iOut) )];
                end
            end
        end
        % -----------------------------------------------------------------
        trimIter(iIter).trimRT(iSub).RT1Correct_temp=trimIter(iIter).trimRT(iSub).RT1Correct;
        trimIter(iIter).trimRT(iSub).RT1Correct(trimIter(iIter).trimRT(iSub).iOut(:)) = 0; %% outlier indexed RTs to zero %%
        trimIter(iIter).trimRT(iSub).RT1CorrectIn=trimIter(iIter).trimRT(iSub).RT1Correct; %only correct and Inlier are NOT zero
        trimIter(iIter).trimRT(iSub).RT1Correct=trimIter(iIter).trimRT(iSub).RT1Correct_temp;
        
        % Condition Grouping
        trimIter(iIter).trimRT(iSub).CFM{1} =...
            trimIter(iIter).trimRT(iSub).RT1(Data(iSub).Condition(:)==0); %car
        trimIter(iIter).trimRT(iSub).CFM{2} =...
            trimIter(iIter).trimRT(iSub).RT1(Data(iSub).Condition(:)==1); %face
        trimIter(iIter).trimRT(iSub).CFM{3} =...
            trimIter(iIter).trimRT(iSub).RT1(Data(iSub).Condition(:)==3); %my
        
        % Declare variables
        trimIter(iIter).trimRT(iSub).TC_CFM = cell(6,1);
        
        for iT = 1:length(trimIter(iIter).trimRT(iSub).RT1)
            % target/control Indexing
            if (Data(iSub).Atarg(iT) == 2) || (Data(iSub).Atarg(iT) == 8)
                trimIter(iIter).trimRT(iSub).iTC(iT) = 0; %control
                % 6 Grouping for average (repeated ANOVA 2*3)
                % only correct and inliers are NOT zero
                switch Data(iSub).Condition(iT)
                    case 0 %car
                        trimIter(iIter).trimRT(iSub).TC_CFM{1} =...
                            [trimIter(iIter).trimRT(iSub).TC_CFM{1}(:);...
                            trimIter(iIter).trimRT(iSub).RT1CorrectIn(iT)];
                    case 1 %face
                        trimIter(iIter).trimRT(iSub).TC_CFM{2} =...
                            [trimIter(iIter).trimRT(iSub).TC_CFM{2}(:);...
                            trimIter(iIter).trimRT(iSub).RT1CorrectIn(iT)];
                    case 3 %my
                        trimIter(iIter).trimRT(iSub).TC_CFM{3} =...
                            [trimIter(iIter).trimRT(iSub).TC_CFM{3}(:);...
                            trimIter(iIter).trimRT(iSub).RT1CorrectIn(iT)];
                end
            else
                trimIter(iIter).trimRT(iSub).iTC(iT) = 1; %target
                % 6 Grouping for average (repeated ANOVA 2*3)
                switch Data(iSub).Condition(iT)
                    case 0 %car
                        trimIter(iIter).trimRT(iSub).TC_CFM{4} =...
                            [trimIter(iIter).trimRT(iSub).TC_CFM{4}(:);...
                            trimIter(iIter).trimRT(iSub).RT1CorrectIn(iT)];
                    case 1 %face
                        trimIter(iIter).trimRT(iSub).TC_CFM{5} =...
                            [trimIter(iIter).trimRT(iSub).TC_CFM{5}(:);...
                            trimIter(iIter).trimRT(iSub).RT1CorrectIn(iT)];
                    case 3 %my
                        trimIter(iIter).trimRT(iSub).TC_CFM{6} =...
                            [trimIter(iIter).trimRT(iSub).TC_CFM{6}(:);...
                            trimIter(iIter).trimRT(iSub).RT1CorrectIn(iT)];
                end % switch of perspective categorization
            end % if of orientation categorization
        end %loop of outliers        
    end %loop of subjects
    
    %% Average calculation for JASP
    for iSub = 1:25
        
        trimIter(iIter).trimRT(iSub).Stat = cell(6,1);
        for iANOVA = 1:6
            % index that EXCLUDES RT=0 for averaging, 
            % leaving only correct and inlier----
            trimIter(iIter).trimRT(iSub).nonZeroIndex{iANOVA} = ...
                find(trimIter(iIter).trimRT(iSub).TC_CFM{iANOVA}(:));
            
            % number of outliers per condition
            % this outlier include BOTH correct and incorrect ones
            trimIter(iIter).trimRT(iSub).OutNum_TC_CFM(iANOVA)=...
                length(trimIter(iIter).trimRT(iSub).Out_TC_CFM{iANOVA}(:));
            % condition별 outlier percentage of all trials per condition
            % this outlier percentage include BOTH correct and incorrect ones
             trimIter(iIter).trimRT(iSub).OutPercent_TC_CFM(iANOVA)=...
                 ( trimIter(iIter).trimRT(iSub).OutNum_TC_CFM(iANOVA)...
                 /length(trimIter(iIter).trimRT(iSub).TC_CFM{iANOVA}(:)))*100;
            
             % make group for only NON ZEROs: correct and inlier
            trimIter(iIter).trimRT(iSub).TC_CFMnonZero{iANOVA} = ...
                trimIter(iIter).trimRT(iSub).TC_CFM{iANOVA}(trimIter(iIter).trimRT(iSub).nonZeroIndex{iANOVA});            
            % average and std  of ONLY correct AND inlier---------------------
            trimIter(iIter).trimRT(iSub).Stat{iANOVA}(1) =...
                mean(trimIter(iIter).trimRT(iSub).TC_CFMnonZero{iANOVA}(:));
            trimIter(iIter).trimRT(iSub).Stat{iANOVA}(2) =...
                std(trimIter(iIter).trimRT(iSub).TC_CFMnonZero{iANOVA}(:));
            
            % fill in the JASP form for convenience---------------------------
            trimIter(iIter).trimRT(iSub).ID = Data(iSub).subName;
            trimIter(iIter).trimRT(iSub).JASP(iANOVA) =...
                trimIter(iIter).trimRT(iSub).Stat{iANOVA}(1); % means
        end
        % pure outlier percentage: no matter correct or not
        trimIter(iIter).trimRT(iSub).OutPercentage=...
            (length(trimIter(iIter).trimRT(iSub).iOut))/480*100;
        
        nonzero4Ave = find(trimIter(iIter).trimRT(iSub).RT1CorrectIn);
        trimIter(iIter).trimRT(iSub).threshold(3)=...
            mean(trimIter(iIter).trimRT(iSub).RT1CorrectIn(nonzero4Ave));%new mean
        trimIter(iIter).trimRT(iSub).threshold(4)=...
            std(trimIter(iIter).trimRT(iSub).RT1CorrectIn(nonzero4Ave));%new std
    end
end
