global class EndOfCampaignScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Date currentDate = date.today();
        List<Campaign> endedCampaign = [SELECT Id, Name, EndDate, IsActive
                                FROM Campaign
                                WHERE EndDate <= :currentDate AND IsActive = true];

        if(endedCampaign.isEmpty() == false){
            for(Campaign currCampaign: endedCampaign){
                EndOfCampaignBatch campBatch = new EndOfCampaignBatch(currCampaign.Id, currCampaign.Name);
                Id batchId = Database.executeBatch(campBatch);
                currCampaign.IsActive = false;
            }
            update endedCampaign;
        }
    }
}


// EndOfCampaignScheduler newJob = new EndOfCampaignScheduler();
// String sch = '0 0 12 1/1 * ? *';
// String jobID = System.schedule('End Of Campaign Scheduler', sch, newJob);