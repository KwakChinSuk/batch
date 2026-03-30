from google.analytics.admin_v1alpha import AnalyticsAdminServiceClient
from google.analytics.admin_v1alpha.types import ListPropertiesRequest
from google.oauth2 import service_account
import cfg

SCOPES = ["https://www.googleapis.com/auth/analytics.readonly"]

creds = service_account.Credentials.from_service_account_file(
    cfg.KEY_PATH, scopes=SCOPES
)
client = AnalyticsAdminServiceClient(credentials=creds)


pcnt = 0 
for account in client.list_accounts():
    print(f"\n📂 Account: {account.name} ({account.display_name})")

    # v1alpha: parent 필드 없음 → filter 문자열 사용
    req = ListPropertiesRequest(
        filter=f"parent:{account.name}",
        show_deleted=False,
    )
    for prop in client.list_properties(request=req):
        print(f"   → {prop.name} | {prop.display_name}")
        pcnt = pcnt + 1

print (pcnt)
if pcnt >= 3 :
    cfg.fn_sendmail ("[중요] gcp 계정 추가","확인 필요")
