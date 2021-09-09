<?php

namespace App\Jobs\Document;

use App\Abstracts\Job;
use App\Interfaces\Job\HasOwner;
use App\Interfaces\Job\HasSource;
use App\Interfaces\Job\ShouldCreate;
use App\Models\Document\Document;
use App\Models\Document\DocumentHistory;

class CreateDocumentHistory extends Job implements HasOwner, HasSource, ShouldCreate
{
    protected $document;

    protected $notify;

    protected $description;

    public function __construct(Document $document, $notify = 0, $description = null)
    {
        $this->document = $document;
        $this->notify = $notify;
        $this->description = $description;

        parent::__construct($document, $notify, $description);
    }

    public function handle(): DocumentHistory
    {
        $description = $this->description ?: trans_choice('general.payments', 1);

        $document_history = DocumentHistory::create([
            'company_id' => $this->document->company_id,
            'type' => $this->document->type,
            'document_id' => $this->document->id,
            'status' => $this->document->status,
            'notify' => $this->notify,
            'description' => $description,
            'created_from' => source_name(),
            'created_by' => user_id(),
        ]);

        return $document_history;
    }
}
