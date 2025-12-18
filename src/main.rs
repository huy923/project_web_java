use mysql::prelude::*;
use mysql::*;
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "mysql://root:@localhost:3306/hotel_management";
    let pool = Pool::new(url)?;
    let conn = pool.get_conn()?;
    let select_query = "SELECT 1";

    Ok(())
}
