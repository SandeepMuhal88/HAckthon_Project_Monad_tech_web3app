import uuid
import time
import qrcode
from io import BytesIO
import base64

def generate_qr(event_id: str) -> dict:
    """
    Generate a time-bound QR code for event
    
    Returns:
        dict with qr_string and qr_image (base64)
    """
    timestamp = int(time.time())
    nonce = uuid.uuid4()
    qr_string = f"{event_id}:{timestamp}:{nonce}"
    
    # Generate QR code image
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(qr_string)
    qr.make(fit=True)
    
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Convert to base64
    buffer = BytesIO()
    img.save(buffer, format='PNG')
    buffer.seek(0)
    img_base64 = base64.b64encode(buffer.getvalue()).decode()
    
    return {
        "qr_string": qr_string,
        "qr_image": f"data:image/png;base64,{img_base64}",
        "event_id": event_id,
        "timestamp": timestamp,
        "expires_at": timestamp + 300  # 5 minutes expiry
    }
