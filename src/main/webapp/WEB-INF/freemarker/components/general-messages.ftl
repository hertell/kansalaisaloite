<#import "/spring.ftl" as spring />
<#import "forms.ftl" as f />
<#import "utils.ftl" as u />

<#escape x as x?html> 
 
<#-- 
 * initiativeVoteInfo
 * 
 * Displays vote count. Shows votes all together and from this service.
 *
 * Requirements:
 * - Initiative state is ACCEPTED
 * - Voting is in progress (date requirement)
 * - Must have at least 1 vote all together
-->
<#macro initiativeVoteInfo>

    <#if votingInfo?? && votingInfo.votingInProggress || initiative.totalSupportCount gt 0>
        <p>
        
        <#if initiative.supportCount != initiative.totalSupportCount && initiative.supportCount gt 0>
            <@u.message key="initiative.totalSupportCount.chunk-1" />
            <span id="support-count-${initiative.id}" class="vote-count-container">
                <span class="vote-count">${initiative.totalSupportCount}</span>
            </span>
            <@u.message key="initiative.totalSupportCount.chunk-2" args=[initiative.totalSupportCount] />
            <span id="internal-support-count-${initiative.id}" class="vote-count-container">
                <span class="vote-count internal">${initiative.supportCount}</span>
            </span><@u.message key="initiative.totalSupportCount.chunk-3" />
            
        <#else>
            <@u.message key="initiative.supportCount.chunk-1" />
            <span id="support-count-${initiative.id}" class="vote-count-container">
                <span class="vote-count">${initiative.totalSupportCount}</span>
            </span> <@u.message key="initiative.supportCount.chunk-2" args=[initiative.totalSupportCount] />
        </#if>
        
        <#-- Show refresh-button only when voting is in progress -->
        <#if votingInfo?? && votingInfo.votingInProggress>
            <span class="js-update-support-count icon-small refresh push pull-down rounded trigger-tooltip hidden" data-id="${initiative.id}" data-target-total="support-count-${initiative.id}" data-target-internal="internal-support-count-${initiative.id}" title="<@u.message "initiative.supportCount.refresh" />"></span>
        </#if>
        
        </p>
    </#if>

</#macro>

<#-- 
 * initiativeVote
 * 
 * Displays one option at time:
 * - Vote-button
 * - User already voted
 * - Initiative is accepted, but voting is not yet started
 *
 * Requirements:
 * - Initiative state is ACCEPTED
-->
<#macro initiativeVote>
    <#-- User already voted -->
    <#if votingInfo?? && votingInfo.votingTime??>
        <#assign userAlreadyVoted>
            <span><@u.message "vote.userAlreadyVoted" /> <@u.localDate votingInfo.votingTime />.</span>            
        </#assign>
        <@u.systemMessageHTML userAlreadyVoted "info" />
        
    <#-- Vote button -->    
    <#elseif votingInfo?? && (votingInfo.allowVotingAction)>
        <#assign votingInfoMessage>
            <#assign href>${urls.help(HelpPage.SECURITY.getUri(locale))}</#assign>
            <@u.messageHTML key="vote.info" args=[href] />
            
            
            
            <#if currentUser.authenticated>
                <br/>
                <p><span class="icon-small arrow-right-3 floated"></span><@u.message "vote.notYetVoted" /></p>
            </#if>
            <a href="${urls.vote(initiative.id)}" class="small-button green" title="<@u.message "vote.btn" />"><span class="small-icon save-and-send"><@u.message "vote.btn" /></span></a>
            
            
        </#assign>
        <@u.systemMessageHTML votingInfoMessage "info" />
        
        <#if initiative.supportStatementPdf>
            <#assign infoMessageSupportStatementPdf><@u.messageHTML key="vote.info.supportStatementPdf" args=["#support-statement-pdf"] /></#assign>
            
            <@u.systemMessageHTML infoMessageSupportStatementPdf "info" />
        </#if>
        
        
    <#-- Initiative is accepted, but voting is not yet started -->
    <#elseif votingInfo?? && (initiative.state == InitiativeState.ACCEPTED && (votingInfo?? &&!votingInfo.votingStarted)) >
        <#assign initiativeAccepted>
            <#assign startDateLocal><@u.localDate initiative.startDate /></#assign>
            <#assign args=[startDateLocal] />
            <@u.messageHTML "initiative.stateInfo.accepted" args />
        </#assign>
        <@u.systemMessageHTML initiativeAccepted "info" />
    </#if>
</#macro>


<#-- 
 * votingSuspended
 * 
 * Voting is suspended. Initiative did not get at least 50 votes within the first month.
 *
 * Requirements:
 * - Initiative state is ACCEPTED
 * - Suspend date exceeded and less than 50 votes
-->
<#macro votingSuspended>
    <#if votingInfo?? && votingInfo.votingSuspended>
        <#assign votingSuspendedHTML>                
            <#assign suspendDate><#if initiative.startDate??><@u.localDate initiative.startDate.plus(requiredMinSupportCountDuration) /></#if></#assign>
            <@u.message key="initiative.votingSuspended" args=[suspendDate, minSupportCountForSearch] />
        </#assign>
        <@u.systemMessageHTML votingSuspendedHTML "info" />
    </#if>
</#macro>


<#-- 
 * votingEnded
 * 
 * Voting is ended. 6 month voting period is exceeded.
 *
 * Requirements:
 * - Initiative state is ACCEPTED
 * - Voting is started in the first place and then also ended.
-->
<#macro votingEnded>
    <#if votingInfo?? && votingInfo.votingStarted && votingInfo.votingEnded>
        <#assign votingEndedHTML>                
            <#assign endDate><#if initiative.startDate??><@u.localDate initiative.endDate /></#if></#assign>
            <@u.message key="initiative.votingEnded" args=[endDate] />
        </#assign>
        <@u.systemMessageHTML votingEndedHTML "info" />
    </#if>
</#macro>

<#-- 
 * supportStatementsRemoved
 * 
 * Support votes are removed from this service. Support vote counts are still visible.
 *
-->
<#macro supportStatementsRemoved>
<#if initiative.supportStatementsRemoved??>
    <#assign supportStatementsRemovedHTML>                
        <#assign supportStatementsRemovedDate><@u.localDate initiative.supportStatementsRemoved /></#assign>
        <@u.message key="initiative.supportStatementsRemoved" args=[supportStatementsRemovedDate] />
    </#assign>
    <@u.systemMessageHTML html=supportStatementsRemovedHTML type="info" cssClass="printable" />
</#if>
</#macro>


 </#escape> 
 
 