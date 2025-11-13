# Aiuta Digital Try-On API Integration

This document explains how the Aiuta Digital Try-On API has been integrated into the Virtual Try-On application.

## API Overview

The Aiuta Digital Try-On API follows a three-step workflow:

1. **Upload Images**: Upload the user's photo and clothing item image to the Aiuta server
2. **Create Generation Operation**: Initiate a try-on operation using the uploaded images
3. **Retrieve Results**: Poll for the operation result to get the processed try-on image

## API Endpoints

All endpoints require the `x-api-key` header for authentication.

### Base URL

```plaintext
https://api.aiuta.com/digital-try-on/v1
```

### 1. Upload Image

```http
POST /uploaded_images
```

**Request:**

- Form data with `image_data` field containing the image file

**Response:**
```json
{
  "id": "user_image-06f5948c-c031-4662-a7c4-4d999b445c86",
  "owner_type": "user",
  "url": "https://storage.googleapis.com/aiuta_prod_external_api_images/external_api/user/examples/uploaded_images/user_image-06f5948c-c031-4662-a7c4-4d999b445c86.jpg"
}
```

### 2. Create Operation

```http
POST /sku_images_operations
```

**Request:**

```json
{
  "uploaded_image_id": "user_image-06f5948c-c031-4662-a7c4-4d999b445c86",
  "sku_id": "dress_image-1234567",
  "sku_catalog_name": "main"
}
```

**Response:**
```json
{
  "operation_id": "operation-12345",
  "details": "Operation created",
  "errors": []
}
```

### 3. Check Operation Status

```http
GET /sku_images_operations/{operation_id}
```

**Response:**
```json
{
  "id": "operation-12345",
  "status": "SUCCESS",
  "error": null,
  "generated_images": [
    {
      "id": "generated_image-12345",
      "owner_type": "user",
      "url": "https://storage.googleapis.com/aiuta_prod_external_api_images/result.jpg",
      "image_url": "https://storage.googleapis.com/aiuta_prod_external_api_images/result.jpg"
    }
  ]
}
```

## Implementation Details

The integration is implemented in two main classes:

1. **TryOnService**: Handles all API calls to the Aiuta service
2. **VirtualTryOnPage**: UI for the user to upload images and view results

### TryOnService

The service encapsulates the API workflow in the `processTryOn` method, which:

1. Uploads both user and dress images
2. Creates a generation operation
3. Polls for operation results until complete
4. Returns the resulting image file

### Error Handling

The implementation includes comprehensive error handling for:

- Network connectivity issues
- API request failures
- Invalid images
- Operation timeouts or failures

## Usage Notes

1. The application requires a valid API key for the Aiuta Digital Try-On API
2. Processing may take up to 2 minutes for high-quality results
3. For best results, use full-body photos with good lighting and clear clothing items

## Current Limitations

1. In the demo implementation, we're using the dress image as the SKU ID. In a real production environment, you would have actual SKU IDs from your catalog.
2. The progress indicators show simulated progress for a better user experience, as the actual API does not provide real-time progress updates.

## Future Improvements

1. Implement caching of results to reduce API calls
2. Add support for predefined models from the Aiuta API
3. Improve error recovery and retry mechanisms
