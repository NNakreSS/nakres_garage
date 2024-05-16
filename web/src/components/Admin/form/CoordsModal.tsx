import {
  Modal,
  ModalContent,
  ModalHeader,
  ModalBody,
  ModalFooter,
  Button,
  useDisclosure,
} from "@nextui-org/react";
import { useAdmin } from "../../../providers/AdminProvider";

export default function () {
  const { isOpen, onOpen, onOpenChange } = useDisclosure();
  const { previewCoords, setPreviewCoords } = useAdmin();

  return (
    <>
      <Button onPress={onOpen}>View</Button>
      <Modal
        backdrop="opaque"
        isOpen={isOpen}
        onOpenChange={onOpenChange}
        classNames={{
          backdrop:
            "bg-gradient-to-t from-zinc-900 to-zinc-900/10 backdrop-opacity-20",
        }}
      >
        <ModalContent>
          {(onClose) => (
            <>
              <ModalHeader className="flex flex-col gap-1">
                Preview Coords
              </ModalHeader>
              <ModalBody>
                {previewCoords?.map((coord: string, key: number) => (
                  <div key={key}>
                    <span>{coord}</span>
                  </div>
                ))}
                {!(previewCoords?.lenght! > 0) && <div>Not Exist</div>}
              </ModalBody>
              <ModalFooter>
                <Button color="danger" variant="light" onPress={onClose}>
                  Close
                </Button>
              </ModalFooter>
            </>
          )}
        </ModalContent>
      </Modal>
    </>
  );
}
