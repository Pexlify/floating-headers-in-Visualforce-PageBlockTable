public class DummyController {
    public List<Account> records {get; set;}

    public DummyController() {
        List<Account> allAccounts = [SELECT Id, Name, Phone FROM Account LIMIT 15];
        records = new List<Account>();
        records.addAll(allAccounts);

        records.addAll(allAccounts);

        records.addAll(allAccounts);

        records.addAll(allAccounts);

        records.addAll(allAccounts);
    }
}